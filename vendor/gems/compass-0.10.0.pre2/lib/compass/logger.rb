module Compass
  class Logger

    DEFAULT_ACTIONS = [:directory, :exists, :remove, :create, :overwrite, :compile, :error, :identical]

    ACTION_COLORS = {
      :error => :red,
      :compile => :green,
      :overwrite => :yellow,
      :create => :green,
      :remove => :yellow,
      :exists => :green,
      :directory => :green,
      :identical => :green
    }

    COLORS = { :clear => 0, :red => 31, :green => 32, :yellow => 33 }

    attr_accessor :actions, :options

    def initialize(*actions)
      self.options = actions.last.is_a?(Hash) ? actions.pop : {}
      @actions = DEFAULT_ACTIONS.dup
      @actions += actions
    end

    # Record an action that has occurred
    def record(action, *arguments)
      emit color(ACTION_COLORS[action]) if Compass.configuration.color_output
      log "#{action_padding(action)}#{action} #{arguments.join(' ')}"
      emit color(:clear) if Compass.configuration.color_output
    end

    def color(c)
      if c && COLORS.has_key?(c.to_sym)
        "\e[#{COLORS[c.to_sym]}m"
      else
        ""
      end
    end

    def emit(msg)
      print msg
    end
    # Emit a log message
    def log(msg)
      puts msg
    end

    # add padding to the left of an action that was performed.
    def action_padding(action)
      ' ' * [(max_action_length - action.to_s.length), 0].max
    end

    # the maximum length of all the actions known to the logger.
    def max_action_length
      @max_action_length ||= actions.inject(0){|memo, a| [memo, a.to_s.length].max}
    end
  end

  class NullLogger
    def record(*args)
    end

    def log(msg)
    end
  end
end
