module AbrStateMethods::GA
  
  PDF_FIELDS = {
    "Text6": {
      method: "middle_name"
    },
    "Text7": {
      method: "last_name"
    },
    "Text8": {
      method: "name_suffix"
    },
    "Text9": {
      method: "address"
    },
    "Text10": {
      method: "city"
    },
    "Text11": {
      method: "zip"
    },
    "Text12": { method: "registration_county_name" }, #residence county
    "Text13": {}, #mailing street
    "Text14": {}, #mailing city
    "Text15": {}, #mailing zip
    "Text16": {}, #mailing county
    "Text17": {
      method: "date_of_birth_mm_dd_yyyy"
    },
    "Text18": {
      method: "phone"
    },
    "Text19": {
      method: "email"
    },

    "Text25": {}, #requestor's relationship to voter
    "Text26": {
      method: "email_if_uocava" #only required if "Elegibility_U" is checked
    },
    "Text5": {
      method: "first_name"
    },
    "Election_Date": {
      value: "11/3/2020"
    },
    "address_has_changed": {
      options: ["Off", "Yes"]
    },
    "type_of_ballot": {
      options: ["Democratic", "Republican", "Non_Partisan"]
    },
    "reason_other": {
      options: ["Off", "disabled", "out_of_country"]
    },
    "Elegibility": {
      options: ["D", "E", "U"]
    },
    "UOCAVA_Status": {
      options: ["MOS", "MST", "OSP", "OST"]
    },
    "Text21": { method: "date_for_signature" }, #today's date
    #"Text23": {}, #today's date assistant
    #voter_signature
    
  }

  

 
  EXTRA_FIELDS = ["has_mailing_address", "assisted_voter", "requestor", "request_electronic_transmission"] 
  
  def form_field_items
    [
      {"type_of_ballot": {type: :radio, required: true }}, 
      {"has_mailing_address": {type: :checkbox}},
      {"Text13": {visible: "has_mailing_address"}},
      {"Text14": {visible: "has_mailing_address"}},
      {"Text15": {visible: "has_mailing_address", min: 5, max: 10}},
      {"Text16": {visible: "has_mailing_address"}},
      #{"address_has_changed": {type: :checkbox, visible: "has_mailing_address"}},
      {"requestor": {type: :checkbox}},
      {"Text25": {visible: "requestor"}},
      {"reason_other": {visible: "requestor", type: :radio, options: ["disabled", "out_of_country"]}},
      {"Elegibility": {type: :radio}},
      {"UOCAVA_Status": {visible: "elegibility_u", type: :radio, }},
      {"request_electronic_transmission": {visible: "elegibility_u", type: :checkbox, }},
    ]
  end
  #e.g.
  # [
  #   {"Security Number": {required: true}},
  #   {"State": {visible: "has_mailing_address", type: :select, options: GeoState.collection_for_select, include_blank: true, }},
  #   {"ZIP_2": {visible: "has_mailing_address", min: 5, max: 10}},
  #   {"identification": {
  #     type: :radio,
  #     required: true,
  #     options: ["dln", "ssn4", "photoid"]}},
  #   {"OR": {visible: "identification_dln", min: 8, max: 8, regexp: /\A[a-zA-Z]{2}\d{6}\z/}},
  #   {"OR_2": {visible: "identification_ssn4", min: 4, max: 4, regexp: /\A\d{4}\z/}},
  # ]
  
  
  def custom_form_field_validations
    if self.has_mailing_address.to_s == "1"
      ["Text13", "Text14", "Text15", "Text16"].each do |f|
        custom_validates_presence_of(f)
        #errors.add(self.class.make_method_name(f), custom_required_message(f)) if self.send(self.class.make_method_name(f)).blank?
      end
    end
    if self.requestor.to_s == "1"
      custom_validates_presence_of("Text25")
      custom_validates_presence_of("reason_other")
    end
    if self.elegibility == "U"
      custom_validates_presence_of("UOCAVA_Status")
    end
  end
  
  def email_if_uocava
    self.elegibility == "U" && self.request_electronic_transmission == "1" ? email : nil
  end
 
end