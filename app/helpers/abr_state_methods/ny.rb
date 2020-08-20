module AbrStateMethods::NY
  
  PDF_FIELDS = {
    "date of birth": {
      method: "date_of_birth_mm_dd_yyyy"
    },
    "suffix": {
      method: "name_suffix"
    },
    "middle initial": {
      method: "middle_initial"
    },
    "first name": {
      method: "first_name"
    },
    "last name or surname": {
      method: "last_name"
    },
    "phone number (optional)": {
      method: "phone"
    },
    "email (optional)": {
      method: "email"
    },
    "county where you live": {},
    "street (Residence)": {
      method: "address_line_1"
    },
    "city (Residence)": {
      method: "city"
    },
    "zip code (Residence)": {
      method: "zip"
    },
    #Date (Applicant Signed)
    "(address of witness to mark)": {},
    "Name of Voter:": {
      method: "full_name"
    },
    #(signature of witness to mark)
    #Date (Applicant Marked)
    #Mark: (Applicant mark in lieu of signature)
    "street number (General (or Special) Election Ballot Mailing Address)": {},
    "street name (General (or Special) Election Ballot Mailing Address)": {},
    "apartment (General (or Special) Election Ballot Mailing Address)": {},
    "city (General (or Special) Election Ballot Mailing Address)": {},
    "state (General (or Special) Election Ballot Mailing Address)": {},
    "zip code (General (or Special) Election Ballot Mailing Address)": {},
    "I authorize (give name): (blank space) to pick up my General (or Special) Election Ballot at the board of elections": {},
    "apartment (Residence)": {
      method: "unit"
    },
    "reason": {
      options: ["absence_from_country", "detention", "permanent_illness", "primary_care", "temporary_illness", "va_resident"]
    },
    "election": {
      options: ["any", "general", "primary", "special"],
      value: "general"
    },
    "deliver_general_ballot": {
      options: ["general_in_person", "general_mail", "general_to_proxy"]
    },
    #"voter_signature"
  }
  EXTRA_FIELDS = ["has_mailing_address", "witness"]
  # e.g.
  # EXTRA_FIELDS = ["has_mailing_address", "identification"]
  
  # def whatever_it_is_you_came_up_with
  #   # TODO when blah is selected it should be "abc" and otherwise left blank
  # end
  
  
  def form_field_items
    [
      {"county where you live": {type: :select, required: true, include_blank: true, options: [
        "Albany",
        "Allegany",
        "Bronx",
        "Broome",
        "Cattaraugus",
        "Cayuga",
        "Chautauqua",
        "Chemung",
        "Chenango",
        "Clinton",
        "Columbia",
        "Cortland",
        "Delaware",
        "Dutchess",
        "Erie",
        "Essex",
        "Franklin",
        "Fulton",
        "Genesee",
        "Greene",
        "Hamilton",
        "Herkimer",
        "Jefferson",
        "Kings",
        "Lewis",
        "Livingston",
        "Madison",
        "Monroe",
        "Montgomery",
        "Nassau",
        "New York City",
        "Niagara",
        "Oneida",
        "Onondaga",
        "Ontario",
        "Orange",
        "Orleans",
        "Oswego",
        "Otsego",
        "Putnam",
        "Queens",
        "Rensselaer",
        "Richmond",
        "Rockland",
        "St. Lawrence",
        "Saratoga",
        "Schenectady",
        "Schoharie",
        "Schuyler",
        "Seneca",
        "Steuben",
        "Suffolk",
        "Sullivan",
        "Tioga",
        "Tompkins",
        "Ulster",
        "Warren",
        "Washington",
        "Wayne",
        "Westchester",
        "Wyoming",
        "Yates",
      ]}},
      {"reason": {type: :radio, required: true}},
      {"deliver_general_ballot": {type: :radio, required: true}},
      {"I authorize (give name): (blank space) to pick up my General (or Special) Election Ballot at the board of elections": {visible: "deliver_general_ballot_general_to_proxy", required: :if_visible}},
      {"has_mailing_address": {type: :checkbox}},
      #TODO- if "has_mailing_address" is left blank, autofill lines 43-48 with residential address
      {"street number (General (or Special) Election Ballot Mailing Address)": {visible: "has_mailing_address", classes: "quarter"}},
      {"street name (General (or Special) Election Ballot Mailing Address)": {visible: "has_mailing_address", classes: "half"}},
      {"apartment (General (or Special) Election Ballot Mailing Address)": {visible: "has_mailing_address", classes: "quarter last"}},
      {"city (General (or Special) Election Ballot Mailing Address)": {visible: "has_mailing_address", classes: "half"}},
      {"state (General (or Special) Election Ballot Mailing Address)": {visible: "has_mailing_address", classes: "quarter", type: :select, options: GeoState.collection_for_select, include_blank: true}},
      {"zip code (General (or Special) Election Ballot Mailing Address)": {visible: "has_mailing_address", classes: "quarter last"}},
      {"witness": {type: :checkbox}},
      {"(address of witness to mark)": {visible: "witness"}},
    ]
  end
  #e.g.
  # [
  #   {"reason_instructions": {type: :instructions}}, *"reason_instructions" does NOT get put into EXTRA_FIELDS
  #   {"County": {type: :select, required: true, include_blank: true, options: [
  #     "Adams",
  #   ]}},
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