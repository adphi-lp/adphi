module BudgetConstants
  BUDGET_NAMES = {
    4101 => "Athletic Chair",
    4121 => "Kitchen Manager: Grease/hood",
    4122 => "Kitchen Manager: Repairs",
    4230 => "President: New Initiatives",
    4241 => "President: Fall Retreat",
    4242 => "President: Spring Retreat",
    4310 => "Kitchen Manager: Fall Food",
    4320 => "Kitchen Manager: Spring Food",
    4420 => "Secretary: Composite",
    4450 => "Treasurer & President: Dues",
    4460 => "Treasurer & President: Ifc",
    4490 => "President: Lambda Phi Pins",
    4530 => "Treasurer",
    4540 => "Community Service Chair",
    4550 => "Literary Chair",
    4601 => "Pledge Trainer: Activities",
    4603 => "Pledge Trainer: Project",
    4633 => "Rush Chair: Spring Rush",
    4634 => "Rush Chair: Fall Rush",
    4641 => "Social Chair: Fall Social",
    4642 => "Social Chair: Spring Social",
    4211 => "Social Chair: Fall Semiformal",
    4212 => "Social Chair: Spring Semiformal",
    4643 => "Fraternity Representative",
    4430 => "Fraternity Representative: Convention",
    4644 => "Society Representative",
    4702 => "House Manager: Electric",
    4703 => "House Manager: Gas",
    4470 => "House Manager: License",
    4704 => "House Manager: Pest Control",
    4705 => "House Manager: Phone",
    4707 => "House Manager: Trash",
    4708 => "House Manager: Water",
    4750 => "House Manager: Workweek",
    4800 => "House Manager: Workday",
    4112 => "House Manager: Iap And Spring House",
    4113 => "House Manager: Fall House",
    4111 => "Summer House Manager: Summer + Mattresses"
  }

  BUDGET_OFFICERS = {
    4101 => :athletic_chairman,
    4121 => :kitchen_manager_current,
    4122 => :kitchen_manager_current,
    4230 => :president_current,
    4241 => :president_fall,
    4242 => :president_spring,
    4310 => :kitchen_manager_fall,
    4320 => :kitchen_manager_spring,
    4420 => :secretary,
    4450 => :treasurer,
    4460 => :treasurer,
    4490 => :president_current,
    4530 => :treasurer,
    4540 => :community_relations_chairman,
    4550 => :literary_chairman,
    4601 => :pledge_trainer,
    4603 => :pledge_trainer,
    4633 => :rush_chairman_spring,
    4634 => :rush_chairman_fall,
    4641 => :social_chairman_fall,
    4642 => :social_chairman_spring,
    4211 => :social_chairman_fall,
    4212 => :social_chairman_spring,
    4643 => :fraternity_representative,
    4430 => :fraternity_representative,
    4644 => :society_representative,
    4702 => :house_manager_current,
    4703 => :house_manager_current,
    4470 => :house_manager_current,
    4704 => :house_manager_current,
    4705 => :house_manager_current,
    4707 => :house_manager_current,
    4708 => :house_manager_current,
    4750 => :house_manager_current,
    4800 => :house_manager_current,
    4112 => :house_manager_spring,
    4113 => :house_manager_fall,
    4111 => :house_manager_current
  }

  POSITIONS_WITH_BUDGET = BUDGET_OFFICERS.values.uniq
end