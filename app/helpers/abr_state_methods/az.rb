module AbrStateMethods::AZ
  
  PDF_FIELDS = {
    "Primary  General Election": {
      options: ["Off", "On"],
      value: "Off"
    },
    "Primary Election Only": {
      options: ["Off", "On"],
      value: "Off"
    },
    "General Election Only": {
      options: ["Off", "On"],
      value: "On"
    },
    "Every Election I authorize the County Recorder to include my name on the PEVL and automatically send": {
      options: ["Off", "On"],
      value: "Off"
    },
    "Democratic": {
      options: ["Off", "On"],
      value: "Off"
    },
    "Republican": {
      options: ["Off", "On"],
      value: "Off"
    },
    "Green Pima County Voters Only": {
      options: ["Off", "On"],
      value: "Off"
    },
    "MunicipalOnly Nonpartisan": {
      options: ["Off", "On"],
      value: "Off"
    },
    "Check this box if you request the County Recorder change your residence and mailing address on your registration": {
      options: ["Off", "On"],
      value: "Off"
    },
    "Check this box if you request the County Recorder change your name on your registration record to the one listed": {
      options: ["Off", "On"],
      value: "Off"
    },
    #Date
    "Phone_Number": {
      method: "phone"
    },
    "First_and_Last_Name": {
      method: "full_name"
    },
    "Residence_Address": {
      method: "full_address_1_line"
    },
    "County_of_Residence": {},
    "Mailing_Address": {},
    "Date_of_Birth": {
      method: "date_of_birth_mm_dd_yyyy"
    },
    "Email_Address": {
      method: "email"
    },
    "Place_of_Birth_or_Drivers_licence_or_last_4_ssn": {},
    #voter_signature

  }
  EXTRA_FIELDS = ["has_mailing_address"]
  # e.g.
  # EXTRA_FIELDS = ["has_mailing_address", "identification"]
  
  def form_field_items
    [
      {"County_of_Residence": {type: :select, required: true, include_blank: true, options: [
        "Apache",
        "Cochise",
        "Coconino",
        "Gila",
        "Graham",
        "Greenlee",
        "La Paz",
        "Maricopa",
        "Mohave",
        "Navajo",
        "Pima",
        "Pinal",
        "Santa Cruz",
        "Yavapai",
        "Yuma",
      ]}},
      {"Place_of_Birth_or_Drivers_licence_or_last_4_ssn": {required: true}},
      {"has_mailing_address": {type: :checkbox}},
      {"Mailing_Address": {visible: "has_mailing_address"}},
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
    # make sure delivery is selected if reason ==3
    # make sure fax is provided if faxtype is selected for delivery
  end
  
 
end