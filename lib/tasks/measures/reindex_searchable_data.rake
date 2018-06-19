namespace :db do
  namespace :measures do
    desc "Measures: Re-index searchable data"
    task reindex_searchable_data: :environment do
      ::Measures::ReindexSearchableData.new.run
    end
  end
end
