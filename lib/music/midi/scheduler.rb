module Music
  module MIDI

    class Scheduler
      attr_accessor :tempo
      attr_reader :rate, :queue, :thread
      
      def initialize(options = {})
        self.tempo = options.fetch(:tempo, 120)
        @rate      = options.fetch(:rate, 0.001)
        @sleep_for = rate / 10.0
        @queue     = []
        @phase     = 0.0
        @origin    = @time = Time.now.to_f
        
        @thread = Thread.new do
          loop { dispatch; advance }
        end
      end
      
      ### Add a new job to be performed at +time+.
      def at(time, &task)
        @queue.push([time.to_f, task])
      end

      def tempo=(bpm)
        @tempo = bpm / 60.0
      end
      
      private
        # Advance the internal clock time and spin until it is reached.
        def advance
          @time += @rate
          loop do
            break if Time.now.to_f > @time
            sleep(@sleep_for) # Don't saturate the CPU
          end
        end
        
        def dispatch
          @phase  += (@time - @origin) * @tempo
          @origin  = @time
          ready, @queue = @queue.partition { |time, task| time <= @phase }
          ready.each { |time, task| task.call(time) }
        end
    end
  end
end
