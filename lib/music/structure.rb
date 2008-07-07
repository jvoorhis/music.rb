require File.join(File.dirname(__FILE__), '../music.rb')

class Array
  def rand
    self[(Music.rand * size).floor]
  end
end

module Music::Structure
  # A MusicStructure is a computation that produces a Surface. Individual
  # MusicStructure instances are compositional building blocks, responsible for
  # both generating individual events and determining the future of the
  # performance.
  class MusicStructure
    include Enumerable
    
    # Sequencing operator: the structure on the rhs will be activated when the
    # current structure has finished.
    def >>(structure)
      @next = structure
    end
    
    # Predicate for whether a future event has been sequenced.
    def has_next?
      !@next.nil?
    end
    
    # Return the next MusicStructure in the sequence, if any.
    def next_structure; @next end
    
    # Return the next MusicObject in its activated state.
    def next
      @next.activate if @next
    end
    
    # Activate the structure before generating an event.
    def activate; self end
    
    # Generate a MusicObject. This should only be called after preparing the
    # structure. This is usually taken care of for you by MusicStructure#next.
    def generate(score)
      raise NotImplementedError, "Subclass responsibility"
    end
    
    # Iterate through the structures reachable from the current structure.
    def structure
      StructureIterator.new(self)
    end
    
    def include?(structure)
      self == structure || has_next? && next_structure.include?(structure)
    end
    
    def splice(structure)
      if has_next?
        next_structure.splice(structure)
      else
        self >> structure
      end
    end
    
    # Convenient access to the RNG
    def rand
      Music::rng.rand
    end
    
    def score
      inject(Silence.new(0)) { |sco, str| sco.seq(str.generate(sco)) }
    end
    
    def each(&block)
      if active = self.activate
        yield active
        if _next = active.next
          _next.each(&block)
        end
      end
    end
  end
  
  class StructureIterator
    include Enumerable
    
    def initialize(head)
      @head = head
    end
    
    def first; @head end
    
    def last; map { |s| s }[-1] end
    
    def include?(structure)
      detect { |s| s == structure } ? true : false
    end
    
    def each
      return if @head.nil?
      cursor = @head
      
      begin
        yield cursor
      end while cursor = cursor.next_structure
    end
  end
  
  class Constant < MusicStructure
    def initialize(event)
      @event = event
    end
    
    def generate(score) @event.dup end
  end
  
  class Interval < MusicStructure
    def initialize(*args) # pitch, duration, effort
      @args = args
    end
    
    def generate(score)
      # Scan backwards for a transposable event.
      if ev = surface.to_a.reverse.detect { |e| e.respond_to?(:transpose) }
        ev.transpose(*@args)
      else
        Silence.new(0)
      end
    end
  end
  
  # Choose randomly from given structures, then proceed.
  class Choice < MusicStructure
    def initialize(*choices)
      @choices = choices
    end
    
    def activate
      choice = @choices.rand
      unless choice.has_next?
        choice = choice.dup
        choice >> @next
      end
      choice.activate
    end
    
    def include?(structure)
      self == structure || @choices.any? { |c| c.include?(structure) } || (has_next? && next_structure.include?(structure))
    end
    
    def splice(structure)
      @choices.each { |c| c.splice(structure) unless c.include?(structure) }
    end
  end
  
  class Cycle < MusicStructure
    def initialize(*structures)
      @structures, @pos = structures, structures.size-1
    end
    
    def activate
      structure = @structures[next_index]
      if has_next?
        structure.splice(@next) unless structure.include?(@next)
      end
      structure.activate
    end
    
    def include?(structure)
      self == structure || @structures.any? { |c| c.include?(structure) } || (has_next? && next_structure.include?(structure))
    end
    
    def splice(structure)
      @structures.each { |c| c.splice(structure) unless c.include?(structure) }
    end
    
    private
      def next_index
        @pos = (@pos + 1) % @structures.size
      end
  end
  
  # Repeats the given MusicStructure a specified number of times, before
  # proceeding.
  class Repeat < MusicStructure
    def initialize(repititions, structure)
      @repititions, @structure = repititions, structure
    end
    
    def activate
      if @repititions.zero?
        @next.activate if has_next?
      else
        @repititions -= 1
        @structure.splice(self) unless @structure.include?(self)
        @structure.activate
      end
    end
    
    def include?(structure)
      self == structure || @structure.include?(structure) || (has_next? && next_structure.include?(structure))
    end
    
    def splice(structure)
      @structure.splice(structure) unless @structure.include?(structure)
    end
  end
  
  # Lifts a Proc into a MusicStructure.
  class Fun < MusicStructure
    def initialize(&proc)
      @proc = proc
    end
    
    def generate(score)
      @proc[score]
    end
  end
  

  ::Kernel.module_eval do
    
    def silence(duration=1)
      Constant.new(Silence.new(duration))
    end
    alias :rest :silence
    
    def note(pitch, duration=1, effort=64)
      Constant.new(Note.new(pitch, duration, effort))
    end
    
    def interval(*args)
      Interval.new(*args)
    end
    
    def choice(*structures)
      Choice.new(*structures)
    end
    
    def cycle(*structures)
      Cycle.new(*structures)
    end
    
    def repeat(rep, structure)
      Repeat.new(rep, structure)
    end
    
    def fun(&proc)
      Fun.new(&proc)
    end
    
    def seq(*structures)
      hd, *tl = structures
      tl.inject(hd) { |s, k| s.structure.last >> k }
      hd
    end    
  end
end

if __FILE__ == $0
  include Music
  
  def example
    (lbl=note(60)) >>
      note(62) >>
      cycle(note(64), note(71)) >>
      choice(lbl,
        repeat(3, lbl) >>
        note(60))
    lbl
  end
  
  score = example.score
  
  Music::SMFTranscription.new.write(score, :name => "Example").save('example')
end
