﻿IMPORT STD;


//********************************** GRANDFATHER *********************************************

f1 := '~thor::base::clueauto::grandfather::daily::inqhist::subject';
f2 := '~thor::base::clueauto::grandfather::daily::inqhist::claim';
f3 := '~thor::base::clueauto::grandfather::daily::account::requirements';
f4 := '~thor::base::clueauto::inqhs::grandfather::daily::bogus::policy';
f5 := '~thor::base::clueauto::inqhs::grandfather::daily::bogus::dl';
f6 := '~thor::base::clueauto::inqhs::grandfather::daily::bogus::ssn';
f7 := '~thor::base::clueauto::inqhs::grandfather::daily::bogus::address';
f8 := '~thor::base::clueauto::inqhs::grandfather::daily::bogus::name'; 
f9 := '~thor::key::clueauto::inqhist::autokey::cnsmr::daily::address_grandfather';
f11 := '~thor::key::clueauto::inqhist::autokey::cnsmr::daily::citystname_grandfather';
f12 := '~thor::key::clueauto::inqhist::autokey::cnsmr::daily::name_grandfather';
f13 := '~thor::key::clueauto::inqhist::autokey::cnsmr::daily::ssn2_grandfather';
f14 := '~thor::key::clueauto::inqhist::autokey::cnsmr::daily::stname_grandfather';
f15 := '~thor::key::clueauto::inqhist::autokey::cnsmr::daily::zip_grandfather';
f16 := '~thor::key::clueauto::inqhist::autokey::cnsmr::daily::policy_grandfather';
f17 := '~thor::key::clueauto::inqhist::autokey::cnsmr::daily::dlno_grandfather';
f18 := '~thor::key::clueauto::inqhist::autokey::cnsmr::daily::payload_grandfather';
f19 := '~thor::key::clueauto::inqhist::autokey::daily::address_grandfather';
f20 := '~thor::key::clueauto::inqhist::autokey::daily::citystname_grandfather';
f21 := '~thor::key::clueauto::inqhist::autokey::daily::name_grandfather';
f22 := '~thor::key::clueauto::inqhist::autokey::daily::ssn2_grandfather';
f23 := '~thor::key::clueauto::inqhist::autokey::daily::stname_grandfather';
f24 := '~thor::key::clueauto::inqhist::autokey::daily::zip_grandfather';
f25 := '~thor::key::clueauto::inqhist::autokey::daily::policy_grandfather';
f26 := '~thor::key::clueauto::inqhist::autokey::daily::dlno_grandfather';
f27 := '~thor::key::clueauto::inqhist::autokey::daily::payload_grandfather';
f28 := '~thor::key::clueauto::inqhist::daily::did_grandfather';
f29 := '~thor::key::clueauto::inqhist::daily::inquiry_grandfather';
f30 := '~thor::key::clueauto::inqhist::daily::acctno_grandfather';
f31 := '~thor::key::clueauto::inqhist::daily::cnsmr::did_grandfather';
f32 := '~thor::key::clueauto::inqhist::daily::refno::claim_grandfather';
f33 := '~thor::key::clueauto::inqhist::daily::inquiry::did_grandfather';
f34 := '~thor::key::clueauto::inqhist::daily::bogus::name_grandfather';
f35 := '~thor::key::clueauto::inqhist::daily::bogus::address_grandfather';
f36 := '~thor::key::clueauto::inqhist::daily::bogus::ssn_grandfather';
f37 := '~thor::key::clueauto::inqhist::daily::bogus::driverslicenseno_grandfather';
f38 := '~thor::key::clueauto::inqhist::daily::bogus::policyno_grandfather';
 
 //***********************************  FATHER ***********************************************
 
/* 
f1 := '~thor::base::clueauto::kcd::father::daily::inqhist::subject';
f2 := '~thor::base::clueauto::kcd::father::daily::inqhist::claim';
f3 := '~thor::base::clueauto::kcd::father::daily::account::requirements';
f4 := '~thor::base::clueauto::kcd::inqhs::father::daily::bogus::policy';
f5 := '~thor::base::clueauto::kcd::inqhs::father::daily::bogus::dl';
f6 := '~thor::base::clueauto::kcd::inqhs::father::daily::bogus::ssn';
f7 := '~thor::base::clueauto::kcd::inqhs::father::daily::bogus::address';
f8 := '~thor::base::clueauto::kcd::inqhs::father::daily::bogus::name'; 

f9 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::daily::address_father';
f11 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::daily::citystname_father';
f12 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::daily::name_father';
f13 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::daily::ssn2_father';
f14 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::daily::stname_father';
f15 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::daily::zip_father';
f16 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::daily::policy_father';
f17 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::daily::dlno_father';
f18 := '~thor::key::clueauto::inqhist::kcd::autokey::cnsmr::daily::payload_father';
f19 := '~thor::key::clueauto::inqhist::kcd::autokey::daily::address_father';
f20 := '~thor::key::clueauto::inqhist::kcd::autokey::daily::citystname_father';
f21 := '~thor::key::clueauto::inqhist::kcd::autokey::daily::name_father';
f22 := '~thor::key::clueauto::inqhist::kcd::autokey::daily::ssn2_father';
f23 := '~thor::key::clueauto::inqhist::kcd::autokey::daily::stname_father';
f24 := '~thor::key::clueauto::inqhist::kcd::autokey::daily::zip_father';
f25 := '~thor::key::clueauto::inqhist::kcd::autokey::daily::policy_father';
f26 := '~thor::key::clueauto::inqhist::kcd::autokey::daily::dlno_father';
f27 := '~thor::key::clueauto::inqhist::kcd::autokey::daily::payload_father';
f28 := '~thor::key::clueauto::inqhist::kcd::daily::did_father';
f29 := '~thor::key::clueauto::inqhist::kcd::daily::inquiry_father';
f30 := '~thor::key::clueauto::inqhist::kcd::daily::acctno_father';
f31 := '~thor::key::clueauto::inqhist::kcd::daily::cnsmr::did_father';
f32 := '~thor::key::clueauto::inqhist::kcd::daily::refno::claim_father';
f33 := '~thor::key::clueauto::inqhist::kcd::daily::inquiry::did_father';
f34 := '~thor::key::clueauto::inqhist::kcd::daily::bogus::name_father';
f35 := '~thor::key::clueauto::inqhist::kcd::daily::bogus::address_father';
f36 := '~thor::key::clueauto::inqhist::kcd::daily::bogus::ssn_father';
f37 := '~thor::key::clueauto::inqhist::kcd::daily::bogus::driverslicenseno_father';
f38 := '~thor::key::clueauto::inqhist::kcd::daily::bogus::policyno_father';
*/ 
 STD.File.ClearSuperFile(f1,false);
 STD.File.ClearSuperFile(f2,false);
 STD.File.ClearSuperFile(f3,false);
 STD.File.ClearSuperFile(f4,false);
 STD.File.ClearSuperFile(f5,false);
 STD.File.ClearSuperFile(f6,false);
 STD.File.ClearSuperFile(f7,false);
 STD.File.ClearSuperFile(f8,false);
 STD.File.ClearSuperFile(f9,false);
 STD.File.ClearSuperFile(f11,false);
 STD.File.ClearSuperFile(f12,false);
 STD.File.ClearSuperFile(f13,false);
 STD.File.ClearSuperFile(f14,false);
 STD.File.ClearSuperFile(f15,false);
 STD.File.ClearSuperFile(f16,false);
 STD.File.ClearSuperFile(f17,false);
 STD.File.ClearSuperFile(f18,false);
 STD.File.ClearSuperFile(f19,false);
 STD.File.ClearSuperFile(f20,false);
 STD.File.ClearSuperFile(f21,false);
 STD.File.ClearSuperFile(f22,false);
 STD.File.ClearSuperFile(f23,false);
 STD.File.ClearSuperFile(f24,false);
 STD.File.ClearSuperFile(f25,false);
 STD.File.ClearSuperFile(f26,false);
 STD.File.ClearSuperFile(f27,false);
 STD.File.ClearSuperFile(f28,false);
 STD.File.ClearSuperFile(f29,false);
 STD.File.ClearSuperFile(f30,false);
 STD.File.ClearSuperFile(f31,false);
 STD.File.ClearSuperFile(f32,false);
 STD.File.ClearSuperFile(f33,false);
 STD.File.ClearSuperFile(f34,false);
 STD.File.ClearSuperFile(f35,false);
 STD.File.ClearSuperFile(f36,false);
 STD.File.ClearSuperFile(f37,false);
 STD.File.ClearSuperFile(f38,false);
