FactoryBot.define do
  factory :chapter, parent: :goods_nomenclature, class: Chapter do
    goods_nomenclature_sid { generate(:goods_nomenclature_sid) }
    goods_nomenclature_item_id { "#{2.times.map { Random.rand(9) }.join}00000000" }
    validity_start_date { Date.today.ago(2.years) }
    status { 'published' }

    trait :with_section do
      after(:create) { |chapter, _evaluator|
        section = FactoryBot.create(:section)
        chapter.add_section section
        chapter.save
      }
    end

    trait :with_note do
      after(:create) { |chapter, _evaluator|
        FactoryBot.create(:chapter_note, chapter_id: chapter.to_param)
      }
    end

    trait :with_description do
      before(:create) { |chapter, evaluator|
        FactoryBot.create(:goods_nomenclature_description, goods_nomenclature_sid: chapter.goods_nomenclature_sid,
                          goods_nomenclature_item_id: chapter.goods_nomenclature_item_id,
                          validity_start_date: chapter.validity_start_date,
                          validity_end_date: chapter.validity_end_date,
                          description: evaluator.description,
                          status: 'published')
      }
    end

  end

  factory :chapter_note do
    chapter

    content { Forgery(:basic).text }
  end

  factory :chapter_section do
    goods_nomenclature_sid { generate(:goods_nomenclature_sid) }
    section_id { generate(:sid) }
  end
end
