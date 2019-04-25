const OriginTypes = Object.freeze({
  ERGA_OMNES: "Erga Omnes",
  GROUP:      "Group",
  COUNTRY:    "Country"
});

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
            <input type="radio" id="measure-origin-erga_omnes" v-model="origins_model.origin_type_selected" name="geographical_area_type2" :value="OriginTypes.ERGA_OMNES" class="radio-inline-group">
            <label for="measure-origin-erga_omnes">Erga Omnes (all origins)</label>
          </div>
          <origin-exclusions :origins_selected="origins_model.erga_omnes" v-if="origins_model.origin_type_selected == OriginTypes.ERGA_OMNES"></origin-exclusions>
        </div>

        <div class="measure-origin">
          <div class="multiple-choice">
            <input type="radio" id="measure-origin-group" v-model="origins_model.origin_type_selected" name="geographical_area_type2" :value="OriginTypes.GROUP" class="radio-inline-group">
            <label>
              <custom-select :options="geographical_groups" label-field="description" code-field="geographical_area_id" value-field="geographical_area_id" placeholder="― select a group of countries ―" v-model="origins_model.group.geographical_area_id" class="origin-select" code-class-name="prefix--region" :on-change="geographicalAreaChanged"></custom-select>
            </label>
          </div>
          <origin-exclusions :origins_selected="origins_model.group" v-if="origins_model.origin_type_selected == OriginTypes.GROUP"></origin-exclusions>
        </div>

        <div class="measure-origin">
          <div class="multiple-choice">
            <input type="radio" id="measure-origin-country" v-model="origins_model.origin_type_selected" name="geographical_area_type2" :value="OriginTypes.COUNTRY" class="radio-inline-group">
            <label v-if="multiple_countries">
              <p v-for="(o, idx) in origins">
                <sub-origin :origin= "o" :already_selected="alreadySelected" :key="o.key">
                Hello
                  <template slot-scope="slotProps">
                    <custom-select :options="slotProps.availableOptions" label-field="description" code-field="geographical_area_id" value-field="geographical_area_id" :placeholder="o.placeholder" v-model="o.id" class="origin-select" code-class-name="prefix--region"></custom-select>
                    <a class="secondary-button" href="#" v-on:click.prevent="removeSubOrigin(idx)" v-if="origins.length > 1 && origins_model.origin_type_selected == OriginTypes.COUNTRY">
                      Remove
                    </a>
                  </template>
                </sub-origin>
              </p>
              <p v-if="origins_model.origin_type_selected == OriginTypes.COUNTRY">
                <a href="#" v-on:click.prevent="addCountryOrTerritory">
                  Add another country
                </a>
                &nbsp;|&nbsp;
                <a href="#" v-on:click.prevent="addGroup">
                  Add another group
                </a>        
              </p>            
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
    let data = {
      geographical_groups: window.geographical_groups_except_erga_omnes,
      all_countries: window.all_geographical_countries,
      OriginTypes: OriginTypes,
      origins: [{
        type: "country",
        placeholder: "― select a country or region ―",
        id: null,
        options: window.all_geographical_countries,
        key: 1
      }],
      key: 2
    };

    if (this.origins_model.country.geographical_area_id instanceof Array && this.origins_model.country.geographical_area_id.length > 0) {
      var arr = [];
      var selected_ids = this.origins_model.country.geographical_area_id;

      selected_ids.forEach(function (id) {
        var isCountry = window.geographical_areas_json[id].length === 0;
        var exclusions = selected_ids.slice(0).filter(function (e) {
          return e != id;
        });

        var options = isCountry ? window.all_geographical_countries : window.geographical_groups_except_erga_omnes;
        var opts = options.filter(function (o) {
          return exclusions.indexOf(o.geographical_area_id) === -1;
        });

        arr.push({
          type: "country",
          placeholder: isCountry ? "― select a country or region ―" : "― select a group of countries ―",
          id: id,
          key: data.key++,
          options: opts
        });
      });

      data.origins = arr;
    }
    return data;
  },
  mounted: function () {
    this.origins_model.erga_omnes.geographical_area_id = "1011";
  },
  computed: {
    alreadySelected: function() {
      return this.origins.map(function(o) {
        return o.id;
      });
    }
  },
  watch: {
    alreadySelected: function() {
      if (!this.multiple_countries) {
        return;
      }

      this.origins_model.country.geographical_area_id = this.origins.map(function(o) {
        return o.id;
      });

      this.origins_model.origin_type_selected = OriginTypes.COUNTRY;
    }
  },
  methods: {
    geographicalAreaChanged: function(newGeographicalArea) {
      this.origins_model.origin_type_selected = OriginTypes.GROUP;
      this.origins_model.group.geographical_area_id = newGeographicalArea;
    },
    countryChanged: function(newCountry) {
      this.origins_model.origin_type_selected = OriginTypes.COUNTRY;
      this.origins_model.country.geographical_area_id = newCountry;
    },
    addCountryOrTerritory: function() {
      this.origins.push({
        type: "country",
        placeholder: "― select a country or region ―",
        id: null,
        options: window.all_geographical_countries,
        key: this.key++
      });
    },
    addGroup: function() {
      this.origins.push({
        type: "group",
        placeholder: "― select a group of countries ―",
        id: null,
        options: window.geographical_groups_except_erga_omnes,
        key: this.key++
      });
    },
    removeSubOrigin: function(index) {
      this.origins.splice(index, 1);
    }
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
