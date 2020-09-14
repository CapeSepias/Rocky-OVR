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
      value: "On" # TODO remove this once we can figure out AZ email handling
    },
    "Every Election I authorize the County Recorder to include my name on the PEVL and automatically send": {
      options: ["Off", "On"],
      value: "Off" # TODO remove this once we can figure out AZ email handling
    },
    "Democratic": {
      options: ["Off", "On"],
    },
    "Republican": {
      options: ["Off", "On"],
    },
    "Green Pima County Voters Only": {
      options: ["Off", "On"],
    },
    "MunicipalOnly Nonpartisan": {
      options: ["Off", "On"],
    },
    "Check this box if you request the County Recorder change your residence and mailing address on your registration": {
      options: ["Off", "On"],
      value: "Off"
    },
    "Check this box if you request the County Recorder change your name on your registration record to the one listed": {
      options: ["Off", "On"],
      value: "Off"
    },
    "Phone_Number": {
      method: "phone"
    },
    "First_and_Last_Name": {
      method: "full_name"
    },
    "Residence_Address": {
      method: "full_address_1_line"
    },
    "County_of_Residence": { method: "registration_county_name" },
    "Mailing_Address": {},
    "Date_of_Birth": {
      method: "date_of_birth_mm_dd_yyyy"
    },
    "Email_Address": {
      method: "email"
    },
    "Place_of_Birth_or_Drivers_licence_or_last_4_ssn": {sensitive: true, method: "identification_data"},
    "Date": {
      method: "date_for_signature"
    }
    #voter_signature

  }

  def signature_pdf_field_name
    "voter_signature"
  end

  EXTRA_FIELDS = ["has_mailing_address", "identification_selection",  {name:"drivers_license_id", sensitive:true}, "place_of_birth", {name:"last_4_ssn", sensitive:true}, "dln_soft_validation"]
  # e.g.
  # EXTRA_FIELDS = ["has_mailing_address", "identification"]
  
  def form_field_items
    [
      #{"election_selection": {type: :radio, options: ["general", "all"], required: true}},
      #{"primary_ballot_selection": {visible: "election_selection_all", required: "custom", type: :radio, options: PARTY_SELECTIONS}},
      {"identification_selection": {required:true, type: :radio, options: ["place_of_birth", "drivers_license_id","last_4_ssn"]}},
      {"drivers_license_id": {required: "star", ui_regexp:"^[a-zA-Z][0-9]{8}$|^[0-9]{9}$", min:8, max:9, visible: "identification_selection_drivers_license_id"}},
      {"last_4_ssn": {required: "star",  min:4, max:4, visible:"identification_selection_last_4_ssn"}},
      {"place_of_birth": {required: "star", min:1, visible: "identification_selection_place_of_birth"}},
      {"has_mailing_address": {type: :checkbox}},
      {"Mailing_Address": {visible: "has_mailing_address"}},
      {"dln_soft_validation": {type: :hidden}}
    ]
  end
  
  def election_selection
    if self.send(self.class.make_method_name("General Election Only")) == "On"
      return "general"
    elsif self.send(self.class.make_method_name("Every Election I authorize the County Recorder to include my name on the PEVL and automatically send")) == "On"
      return "all"
    else
      return nil
    end
  end
  
  def election_selection=(val)
    self.send("#{self.class.make_method_name("General Election Only")}=", "Off")
    self.send("#{self.class.make_method_name("Every Election I authorize the County Recorder to include my name on the PEVL and automatically send")}=", "Off")
    if val == "general"
      self.send("#{self.class.make_method_name("General Election Only")}=", "On")      
    elsif val == "all"
      self.send("#{self.class.make_method_name("Every Election I authorize the County Recorder to include my name on the PEVL and automatically send")}=", "On")
    end
  end

  def identification_data
    case self.identification_selection
    when "drivers_license_id"
     return (self.drivers_license_id())
    when "last_4_ssn"
      return (self.last_4_ssn())
    when "place_of_birth"
      return (self.place_of_birth())
    else
      return "Missing identification"
    end
  end


  PARTY_SELECTIONS = [
     "democratic", "republican", "green_pima_county_voters_only", "municipalonly_nonpartisan"
  ]


  def primary_ballot_selection
    PARTY_SELECTIONS.each do |p|
      if self.send(p) == "On"
        return p
      end
    end
  end
  
  def primary_ballot_selection=(value)
    self.democratic = "Off"
    self.republican = "Off"
    self.green_pima_county_voters_only = "Off"
    self.municipalonly_nonpartisan = "Off"
    if self.respond_to?("#{value}=")
      self.send("#{value}=", "On")
    end
  end


    
  
  def custom_form_field_validations
    if self.has_mailing_address.to_s == "1"
      custom_validates_presence_of("Mailing_Address")
    end

    if !self.identification_selection.blank?
      custom_validates_presence_of(self.identification_selection)
    end
    
    if self.election_selection == "all"
      custom_validates_presence_of("primary_ballot_selection")
    end
    
    if self.primary_ballot_selection == "green_pima_county_voters_only"
      if self.registration_county != "pima county"
        errors.add(:primary_ballot_selection, "Green party is for Pima county voters only")
      end
    end

  end    
   
end