# encoding: utf-8

RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.main_app_name = ["ΑΔΦ ΛΦ"]

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.included_models = ["Brother", "PledgeClass", "Meeting"]

  config.model 'Brother' do
    configure :meetings do
      hide
    end

    configure :position do
      searchable false
    end
  end

  config.model 'Balance' do
    configure :kind do
      searchable false
    end
  end

  config.authorize_with do
    unless current_brother && current_brother.admin?
      redirect_to '/', flash: {alert: 'You are not authorized to access the backend. '}
    end
  end
end
