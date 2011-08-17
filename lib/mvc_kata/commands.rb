module MvcKata
  module Command
    class Base
      attr_accessor :who, :whom

      def initialize(who, whom)
        self.who, self.whom = who, whom
      end

      def execute
      end
    end

    class Attack < Base
      def execute
        who.attack(whom)
      end
    end

    class Cure < Base
      class << self
        attr_accessor :power
      end

      def execute
        who.cure(self.class.power)
      end
    end

    def self.Cure(power)
      Class.new(Cure) { self.power = power }
    end
  end
end

