CREATE VIEW pa_rad.campaign_results_IDC as
(SELECT
     CAST(OTHER.van_id as varchar) as vanid
    ,CAST(OTHER.contacttypename as varchar) as contact_type
    ,CAST(first_name as varchar) as contact_firstname
    ,CAST(last_name as varchar) as contact_lastname
    ,CAST(registration_address_line_1 as varchar) as address
    ,CAST(initcap( registration_address_city) as varchar) as city
    ,CAST(registration_address_state as varchar) as state
    ,CAST(registration_address_zip as varchar) as zipcode
    ,CAST(likely_cell_phone as VARCHAR) phonenumber
    ,CAST(OTHER.canvassedby as varchar) as agent_id
    ,CAST(OTHER.resultshortname as varchar) as disposition
    ,CAST(OTHER.datecanvassed as datetime) as date
    ,CAST(OTHER.initial_rating as varchar)
    ,CAST(OTHER.knows_immigrant.surveyresponsename as varchar) as knows_immigrant
    ,CAST(OTHER.cog_dis.surveyresponsename as varchar) as cog_dis
    ,CAST(OTHER.add_conc.surveyresponsename as varchar) as add_conc
    ,CAST(OTHER.final_rating as varchar) as final_rating
    ,CAST(OTHER.call_senator.surveyresponsename as varchar) as call_senator
from
     tmc_av_van.pa_rad_av_contacts_contacts pracas
     left join tmc_av_van.av_tmc_contacttypes ct on ct.contacttypeid=pracas.contacttypeid
     left join tmc_av_van.av_tmc_results atr on atr.resultid=pracas.resultid
     left join pa_rad_van.contacts c on pracas.tmc_id=c.tmcid
     left join (SELECT DISTINCT canvassedby_ID, canvassedby_username FROM tmc_av_van.pa_rad_av_contact_attempts_summary where canvassedby_username is not null ) u on u.canvassedby_ID=pracas.canvassedby
     left join (Select distinct contactscontactid,trim( left(surveyresponsename,2))::int as initial_rating from
    tmc_av_van.pa_rad_av_survey_responses_summary prasrs
    where
    surveyquestionname like 'IDC:%'
    and surveyquestionname='IDC: Support Initial'
    ) started_convo on started_convo.contactscontactid=pracas.contactscontactid
left join (Select distinct contactscontactid,trim( left(surveyresponsename,2))::int as final_rating from
    tmc_av_van.pa_rad_av_survey_responses_summary prasrs
    where
    surveyquestionname='IDC: Support Final'
    ) completed_convo on completed_convo.contactscontactid=pracas.contactscontactid
left join (Select distinct contactscontactid,surveyresponsename from
    tmc_av_van.pa_rad_av_survey_responses_summary prasrs
    where
    surveyquestionname='IDC: Call Senator'

    ) call_senator on call_senator.contactscontactid=pracas.contactscontactid
left join (Select distinct contactscontactid,surveyresponsename from
    tmc_av_van.pa_rad_av_survey_responses_summary prasrs
    where
    surveyquestionname='IDC: Knows Immigrant'

    ) knows_immigrant on knows_immigrant.contactscontactid=pracas.contactscontactid
left join (Select distinct contactscontactid,surveyresponsename from
    tmc_av_van.pa_rad_av_survey_responses_summary prasrs
    where
    surveyquestionname='IDC: Cognitive Diss'

    ) cog_dis on cog_dis.contactscontactid=pracas.contactscontactid
left join (Select distinct contactscontactid,surveyresponsename from
    tmc_av_van.pa_rad_av_survey_responses_summary prasrs
    where
    surveyquestionname='IDC: Address Concern'

    ) add_conc on add_conc.contactscontactid=pracas.contactscontactid
WHERE pracas.campaignid=34136 and contacttypename='Walk'
UNION ALL
SELECT
campaign_name
,van_id
,contact_firstname
,contact_lastname
,household_of
,email
, address
, city
, state
, zipcode
, company_name
,phonenumber
,callerid
, crs.agent
, icn.canvasser as agent_names
,disposition
, date
,duration
,billed_duration
,tags
,vanid213544
,set_call_disposition
,van_question_on_a_scale_from_110_where_0_is_against_and_10_is_in_favor_and_5_is_undecided_where_would_you_put_yourself_in_terms
,van_question_do_you_know_anyone_who_has_immigrated_to_the_us
,van_question_did_you_process_cognitive_dissonance_with_the_voter_you_were_speaking_to
,van_question_did_you_need_to_address_any_concerns_with_the_voter_such_as_taxes
,van_question_after_this_conversation_where_would_you_place_yourself_on_the_scale_of_support_where_0_is_against_and_10_is_in_fav
,van_question_can_you_make_a_call_right_now_to_senator_shaheen_and_hassan_urging_them_to_vote_yes_on_immigration_reform
,van_question_would_you_like_to_sign_up_to_receive_text_messages_from_rights_and_democracy_and_our_sister_c3_organization_rights
,notes
FROM pa_rad.callhub_results_slow_20210922_to_20211104 crs
left join pa_rad.idc_canvasser_names icn on crs.agent=icn.agent
UNION ALL
SELECT
campaign_name
,van_id
,contact_firstname
,contact_lastname
,household_of
,email
, address
, city
, state
, zipcode
, company_name
,phonenumber::varchar
,callerid::varchar
, crfl.agent
,icn.canvasser as agent_names
,disposition
, date::timestamptz
,duration
,billed_duration
,tags
,vanid150115
,set_call_disposition
,van_question_to_start_us_off_given_what_you_know_do_you_think_youd_be_in_favor_or_against_this_kind_of_bill_on_this_scale_where
,van_question_do_you_know_anyone_who_has_immigrated_to_the_us
,van_question_did_you_process_cognitive_dissonance_with_the_voter_you_were_speaking_to
,van_question_did_you_need_to_address_any_concerns_with_the_voter_such_as_taxes
,van_question_thank_you_for_talking_to_me_to_go_back_to_that_scale_where_0_is_against_and_10_is_in_favor_where_would_you_put_you
,van_question_can_you_make_a_call_right_now_to_senator_shaheen_and_hassan_urging_them_to_vote_yes_on_immigration_reform_select_y
,van_question_would_you_like_to_sign_up_to_receive_text_messages_from_rights_and_democracy_and_our_sister_c3_organization_rights
,notes
FROM pa_rad.callhub_results_fast_latest crfl
left join pa_rad.idc_canvasser_names icn on crfl.agent=icn.agent
)
with no schema binding;
