require 'rails_helper'

RSpec.describe InlineProjector do
  def stub_class(name, superclass = nil, &block)
    context = self
    stub_const(name.to_s.camelize, Class.new(superclass || Object)).tap do |klass|
      klass.class_exec(context, &block) if block_given?
    end
  end

  before do
    stub_class 'DummyUser', ApplicationRecord do
      self.table_name = 'users'
    end

    stub_class('DummyAction', BaseAction) do
      projector :inline 

      subject :user, class_name: 'DummyUser'
      attribute :test_failure, String

      precondition do
        decline_with(:no_button) if test_failure == 'no_button'
      end

      precondition do
        decline_with if test_failure == 'other'
      end
    end
  end

  draw_routes do
    resources :users do
      granite 'dummy_action#inline', on: :member
    end
  end

  projector { DummyAction.inline }
  let(:action) { DummyAction.as(double).new(DummyUser.new(id: 1), params) }
  let(:params) { {} }

  describe 'button' do
    subject { action.inline.button }

    it { is_expected.to eq('<a rel="nofollow" data-method="post" href="/users/1/dummy_action">Dummy action</a>') }

    context 'with failed no_button precondition' do
      before { params[:test_failure] = 'no_button' }

      it { is_expected.to be_nil }
    end
  end
end
