class BaseAction < Granite::Action

  class ValidateAllStrategy
    def self.allowed?(action)
      action._policies.all?{ |policy| action.instance_exec(action.performer, &policy) }
    end
  end
  self._policies_strategy = ValidateAllStrategy
end
