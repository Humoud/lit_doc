class LitDoc::Railtie < Rails::Railtie
  rake_tasks do
    load 'tasks/lit_doc.rake'
  end
end
