module Music
  module MIDI

    class Scheduler
      attr_accessor :tempo
      attr_reader :rate, :queue, :thread
      
      def initialize(options = {})
        @tempo  = options.fetch(:tempo, 120)
        @rate   = options.fetch(:rate, 0.001)
        @queue  = []
        @epoch  = Time.now.to_f
        @phase  = 0.0
        @thread = Thread.new do
          loop do
            dispatch
            sleep(@rate)
          end
        end
      end
      
      ### Add a new job to be performed at +time+.
      def at(time, &task)
        @queue.push([time.to_f, task])
      end
      
      private
        def dispatch
          now     = Time.now.to_f
          elapsed = now - @epoch
          @epoch  = now
          @phase  += (elapsed * @tempo / 60.0)
          ready, @queue = @queue.partition { |time, task| time <= @phase }
          ready.each { |time, task| task[time] }
        end
    end
  end
end
