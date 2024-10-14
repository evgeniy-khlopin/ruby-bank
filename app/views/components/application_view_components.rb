class ApplicationViewComponent < ViewComponent::Base
  include ApplicationHelper

  class << self
    def component_name
      @component_name ||= name.sub(/::Component$/, '').underscore
    end
  end

  def component(name, ...)
    return super unless name.starts_with?('.')

    full_name = self.class.component_name + name.sub('.', '/')

    super(full_name, ...)
  end
end
