Vue.component("origin", {
  props: {
    record_type: String,  // 'measure' or 'quota'
    origins_model: Object,
    new_area_url: String, // url for user to add new areas
    multiple_countries: Boolean
  },
  template:
    `<div>
      <fieldset>

        <h3 class="heading-medium">
          Which origin will the {{ record_type }} apply to?
        </h3>
        <span class="form-hint">
          You can specify a single country or territory, or a pre-defined group of countries, or select
          'Erga Omnes' to apply the quota to all origins. If the group you need is not in the list, you
          can <a :href=new_area_url>add it from here</a>.
        </span>
        <div class="measure-origin">
          <div class="multiple-choice">
            <input type="radio" id="measure-origin-erga_omnes" v-model="origin_type" name="geographical_area_type2" value="erga_omnes" class="radio-inline-group">
            <label for="measure-origin-erga_omnes">Erga Omnes (all origins)</label>
          </div>
          <origin-exclusions :origins_selected="origins_model.erga_omnes" v-if="origin_type == 'erga_omnes'"></origin-exclusions>
        </div>

        <div class="measure-origin">
          <div class="multiple-choice">
            <input type="radio" id="measure-origin-group" v-model="origin_type" name="geographical_area_type2" value="group" class="radio-inline-group">
            <label>
              <custom-select :options="geographical_groups" label-field="description" code-field="geographical_area_id" value-field="geographical_area_id" placeholder="― select a group of countries ―" v-model="origins_model.group.geographical_area_id" class="origin-select" code-class-name="prefix--region" :on-change="geographicalAreaChanged"></custom-select>
            </label>
          </div>
          <origin-exclusions :origins_selected="origins_model.group" v-if="origin_type == 'group'"></origin-exclusions>
        </div>

        <div class="measure-origin">
          <div class="multiple-choice">
            <input type="radio" id="measure-origin-country" v-model="origin_type" name="geographical_area_type2" value="country" class="radio-inline-group">
            <label v-if="multiple_countries">
<!--              <p v-for="(o, idx) in origins">-->
<!--                = content_tag "sub-origin", { ":origin" => "o", ":already_selected" => "alreadySelected", ":key" => "o.key"} do-->
<!--                  template slot-scope="slotProps"-->
<!--                    = content_tag "custom-select", "", { ":options" => "slotProps.availableOptions", "label-field" => "description", "code-field" => "geographical_area_id", "value-field" => "geographical_area_id", ":placeholder": "o.placeholder", "v-model" => "o.id", class: "origin-select", "code-class-name" => "prefix&#45;&#45;region", ":on-change" => "geographicalAreaChanged" }-->
<!--                    a.secondary-button href="#" v-on:click.prevent="removeSubOrigin(idx)" v-if="origins.length > 1 && origin.selected"-->
<!--                 Remove-->
<!--              </p>-->
<!--              <p v-if="origin.selected">-->
<!--                <a href="#" v-on:click.prevent="addCountryOrTerritory">-->
<!--                  Add another country-->
<!--                </a>-->
<!--                &nbsp;|&nbsp;-->
<!--                <a href="#" v-on:click.prevent="addGroup">-->
<!--                  Add another group-->
<!--                </a>        -->
<!--              </p>            -->
            </label>
            <label v-else>
              <custom-select :options="all_countries" label-field="description" code-field="geographical_area_id" value-field="geographical_area_id" placeholder="― select a country or region ―" v-model="origins_model.country.geographical_area_id" class="origin-select" code-class-name="prefix--region" :on-change="countryChanged"></custom-select>
            </label>
          </div>
        </div>
   
      </fieldset>
    </div>
    `,
  data: function () {
    const data = {
      geographical_groups: window.geographical_groups_except_erga_omnes,
      all_countries: window.all_geographical_countries,
      origin_type: null,
      key: 2,
    };
    return data;
  },
  mounted: function () {
    if (this.origins_model.erga_omnes.selected) {
      this.origin_type = "erga_omnes";
    } else if (this.origins_model.group.selected) {
      this.origin_type = "group";
    } else if (this.origins_model.country.selected) {
      this.origin_type = "country";
    } else {
      this.origin_type = null;
    }
  },
  computed: {},
  watch: {
    origin_type: function(newVal, oldVal) {
      if (newVal == "erga_omnes") {
        this.origins_model.erga_omnes.geographical_area_id = "1011";
        this.origins_model.erga_omnes.selected = true;
        this.origins_model.group.selected = false;
        this.origins_model.country.selected = false;
      } else if (newVal == "group") {
        this.origins_model.erga_omnes.selected = false;
        this.origins_model.group.selected = true;
        this.origins_model.country.selected = false;
      } else if (newVal == "country") {
        this.origins_model.erga_omnes.selected = false;
        this.origins_model.group.selected = false;
        this.origins_model.country.selected = true;
      }
    }
  },
  methods: {
    geographicalAreaChanged: function(newGeographicalArea) {
      this.origin_type = "group";
      this.origins_model.group.geographical_area_id = newGeographicalArea;
    },
    countryChanged: function(newCountry) {
      this.origin_type = "country";
      this.origins_model.country.geographical_area_id = newCountry;
    },
  }
});

Vue.component("origin-exclusions", {
  props:{
    origins_selected: Object
  },
  template:
    `
    <div class="panel panel-border-narrow">
      <label class="form-label">
        If you want to exclude countries from this measure, enter them here:
      </label>
      <div class="exclusions-target">
        <div class="exclusion" v-for="exclusion in origins_selected.exclusions" :key="exclusion.uid">
          <div class="exclusion-select">
            <custom-select :options="exclusion.options" label-field="description" code-field="geographical_area_id" value-field="geographical_area_id" placeholder="― start typing ―" min-length=1 v-model="exclusion.geographical_area_id" class="origin-select" code-class-name="prefix--country" >
            </custom-select>
          </div>
            
          <div class="exclusion-actions" v-if="origins_selected.exclusions.length > 1">
            <a class="remove-link" v-on:click.prevent="removeExclusion(exclusion)">
              Remove
            </a>
          </div>     
        </div>
      </div>    
      <p class="add-another-wrapper">
        <a href="#" v-on:click.prevent="addExclusion">
          Add another exclusion            
        </a>
      </p>    
    </div>
  `,
  mounted: function () {
    if (this.origins_selected.exclusions.length < 1) {
      this.addExclusion();
    }
  },
  methods: {
    addExclusion: function () {
      var options = this.getExclusionOptions(this.origins_selected.geographical_area_id);
      this.origins_selected.exclusions.push({
        geographical_area_id: null,
        options: options,
        uid: new Date().valueOf()
      });
    },
    getExclusionOptions: function (geographicalAreaId) {
      if (this.multiple) {
        return [];
      }

      var currentExclusions = this.getCurrentExclusionsArray(),
        areas = window.geographical_areas_json[geographicalAreaId];
      return areas.slice().filter(function (area) {
        return !currentExclusions.includes(area.geographical_area_id);
      });
    },
    getCurrentExclusionsArray: function () {
      return this.origins_selected.exclusions.reduce(function (memo, exclusion) {
        if (exclusion.geographical_area_id) {
          return memo.concat(exclusion.geographical_area_id);
        }
        return memo;
      }, []);
    },
    removeExclusion: function (exclusion) {
      var index = this.origins_selected.exclusions.indexOf(exclusion);

      if (index === -1) {
        return;
      }

      this.origins_selected.exclusions.splice(index, 1);
      this.changeExclusion();
    },
    changeExclusion: function () {
      var currentExclusions,
        self = this;
      currentExclusions = this.getCurrentExclusionsArray();
      // reset exclusions:
      this.origins_selected.exclusions.forEach(function (exclusion) {
        exclusion.options = window.geographical_areas_json[self.origins_selected.geographical_area_id].slice();
      });
      // remove current exclusions from options:
      currentExclusions.forEach(function (chosenExclusionId) {
        self.origins_selected.exclusions.forEach(function (exclusion) {
          var selected = exclusion.geographical_area_id == chosenExclusionId;
          if (!selected) {
            var selectedExclusion = exclusion.options.find(function (opt) {
              return opt.geographical_area_id == chosenExclusionId;
            });
            var idx = exclusion.options.indexOf(selectedExclusion);
            exclusion.options.splice(idx, 1);
          }
        });
      });
    },
  }
});
