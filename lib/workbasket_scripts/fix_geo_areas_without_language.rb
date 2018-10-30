module WorkbasketScripts
  class FixGeoAreasWithoutLanguage

    class << self
      def run
        fix_wrong_language_records!
        fix_wrong_geo_code_records!
      end

      private

        def fix_wrong_language_records!
          log_it("#{target_scope.count} detected. Started fixing process...")

          target_scope.map do |item|
            item.manual_add = true
            item.language_id = "EN"
            item.save
          end

          log_it("#{target_scope.count} detected. Fixing process successfuly completed.")

          final_check
        end

        def fix_wrong_geo_code_records!
          log_it("Fixing records with wrong geo codes...")

          group_scope.map do |item|
            fix_geo_code!(item, '1')
          end

          country_scope.map do |item|
            fix_geo_code!(item, '0')
          end

          region_scope.map do |item|
            fix_geo_code!(item, '2')
          end

          log_it("Fixing process successfuly completed.")
        end

        def fix_geo_code!(item, geo_code)
          item.manual_add = true
          item.geographical_code = geo_code
          item.save
        end

        def target_scope
          GeographicalAreaDescription.where("language_id IS NULL")
        end

        def group_scope
          GeographicalArea.where(geographical_code: "group")
        end

        def country_scope
          GeographicalArea.where(geographical_code: "country")
        end

        def region_scope
          GeographicalArea.where(geographical_code: "region")
        end

        def final_check
          log_it("Final check, scanning results: #{target_scope.count}")
        end

        def log_it(message)
          puts ""
          puts "-" * 100
          puts ""
          puts " #{message}"
          puts ""
          puts "-" * 100
          puts ""
        end
    end
  end
end
