class InlineProjector < Granite::Projector

  post :perform, as: '' do
    if action.perform!
      redirect_to projector.success_redirect, notice: t('.notice')
    else
      messages = projector.action.errors.full_messages.to_sentence
      redirect_to projector.failure_redirect, alert:  t('.error', messages)
    end
  end

  def collection_subject
    action.subject.class.name.downcase.pluralize
  end

  def success_redirect
    h.public_send("#{collection_subject}_path")
  end

  def build_action(*args)
    action_class.as(self.class.proxy_performer || h.current_user).new(*args)
  end

  def action_label
    action.class.name.demodulize.underscore.humanize
  end

  def button(link_options = {})
    return unless action.allowed?
    if action.performable?
      h.link_to action_label, perform_path, method: :post
    else
      h.content_tag(:strike, action_label, title: action.errors.full_messages.to_sentence)
    end
  end
end
