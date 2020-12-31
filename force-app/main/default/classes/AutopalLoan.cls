global class AutopalLoan {
	public String loan_title {get;set;} 
	public String loan_instance {get;set;} 
	public String loan_class_a {get;set;} 
	public String loan_class_b {get;set;} 
	public String loan_class_c {get;set;} 
	public String loan_class_d {get;set;} 
	public String loan_classification {get;set;} 
	public String loan_active {get;set;} 
	public String loan_alert {get;set;} 
	public String loan_search {get;set;} 
	public String loan_status {get;set;} 
	public String loan_checklist {get;set;} 
	public String loan_c {get;set;} 
	public String loan_id {get;set;} 
	public String loan_substatus {get;set;} 
	public String loan_insurance_exp {get;set;} 
	public String loan_search_col {get;set;} 
	public String loan_search_ins {get;set;} 
	public String loan_search_ref {get;set;} 
	public String lnst_date_next_payment {get;set;} 
	public String lnst_date_last_current {get;set;} 
	public String lnst_amount_due {get;set;} 
	public String lnst_amount_next_payment {get;set;} 
	public String lnst_amount_principle_balance {get;set;} 
	public String lnst_amount_past_due_30 {get;set;} 
	public String lnst_past_due_days {get;set;} 
	public String lnst_payoff {get;set;} 
	public String lnst_status {get;set;} 
	public String lnst_stoplight {get;set;} 
	public String bwms_name_first {get;set;} 
	public String bwms_name_last {get;set;} 
	public String bwms_name_middle {get;set;} 
	public String bwms_phone {get;set;} 
	public String bwms_search {get;set;} 
	public String loan_type {get;set;} 
	public String loan_amount {get;set;} 
	public String loan_uwfee {get;set;} 
	public String loan_discount {get;set;} 
	public String loan_dealer_profit {get;set;} 
	public String lnst_chargeoff {get;set;} 
	public String loan_altId {get;set;} 
	public String loan_calc_type {get;set;} 
	public String lnst_avail_credit {get;set;} 
	public String lnst_credit_limit {get;set;} 
	public String loan_secured {get;set;} 
	public String loan_displayAltId {get;set;} 
	public String loan_contract {get;set;} 
	public String loan_contract_orig {get;set;} 
	public String loan_isSetup {get;set;} 
	public String bwms_ssn {get;set;} 
	public String loan_search_bwr {get;set;} 
	public String loan_search_cst {get;set;} 
	public String loan_import_id {get;set;} 
	public String lnst_due_interest {get;set;} 
	public String lnst_due_principle {get;set;} 
	public String lnst_due_fees {get;set;} 
	public String lnst_aging {get;set;} 
	public String loan_displayId {get;set;} 
	public String lnst_due_escrow {get;set;} 
	public String lnst_due_hold {get;set;} 
	public String lnst_perdiem {get;set;} 
	public String loan_first_payment {get;set;} 
	public String loan_rate {get;set;} 
	public String loan_pmt_amount {get;set;} 
	public String loan_disc_split {get;set;} 
	public String loan_disc_calc {get;set;} 
	public String loan_pmt_freq {get;set;} 
	public String loan_archived {get;set;} 
	public String lnst_human_activity {get;set;} 
	public String loan_lastCalcRun {get;set;} 
	public String loan_activity {get;set;} 
	public String loan_qb_synced {get;set;} 
	public String loan_final_payment {get;set;} 
	public String loan_pmt_debit {get;set;} 
	public String loan_pmt_echeck {get;set;} 
	public String loan_pmt_pnm {get;set;} 
	public String loan_last_pmt_date {get;set;} 
	public String loan_last_pmt_amount {get;set;} 
	public String loan_co_name {get;set;} 
	public String lnst_ap_balance {get;set;} 
	public String lnst_qb_balance {get;set;} 
	public String loan_created {get;set;} 
	public String lnst_qb_diff {get;set;} 
	public String loan_modifiedfrom {get;set;} 
	/*public Object lins_company {get;set;} 
	public Object lins_insured {get;set;} 
	public Object lins_agent {get;set;} 
	public Object lins_policy {get;set;} 
	public Object lins_phone {get;set;} 
	public Object lins_deductible {get;set;} 
	public Object lins_startDate {get;set;} 
	public Object lins_endDate {get;set;}*/
	public String loan_search_flag {get;set;} 
	public String loan_search_vbt {get;set;} 
	public String loan_book_value {get;set;} 
	public String loan_name {get;set;} 
	public String bwms_id_type {get;set;} 
	public String loan_ltv {get;set;} 
	public String loan_aging {get;set;} 
	public String loan_phone {get;set;} 
	public String loan_pni_due {get;set;} 
    public Summary summary {get;set;}
    public Collateral collateral {get;set;}
    public InitialSetup initialSetup {get;set;}
    public Settings settings {get;set;}
    public UserInformation userInformation {get;set;}
    
    public class UserInformation{
        public Borrower borrower {get;set;}
    }
    
    public class Borrower{
        public String id {get;set;}
        public DateOfBirth dob {get;set;}
        public NameData name {get;set;}
        public String country {get;set;}
        public String ssn {get;set;}
        public String gender {get;set;}
        public String companyContact {get;set;}
        public String idType {get;set;}
        public String email {get;set;}
        public String primaryPhone {get;set;}
        public String secondaryPhone {get;set;}
        public Address primaryAddress {get;set;}
        public Address mailAddress {get;set;}
    }
    
    public class Address{
        public String address {get;set;}
        public String city {get;set;}
        public String state {get;set;}
        public String zipCode {get;set;}
        public String country {get;set;}
    }
   	
    public class NameData{
        public String first {get;set;}
        public String middle {get;set;}
        public String last {get;set;}
        public String generation {get;set;}
    }
    
    public class DateOfBirth{
        public String date_z {get;set;}
        public Integer timezone_type {get;set;}
        public String timezone {get;set;}
    }
    
    public class Settings{
        public DataValue sourceCompany {get;set;}
        public DataValue subStatus {get;set;}
        public DataValue primaryPortfolio {get;set;}
        public DataValue secondaryPortfolio {get;set;}
    }
    
    public class DataValue{
        public String key {get;set;}
        public String value {get;set;}
    }
    
    public class InitialSetup{
        public String loanFrequency {get;set;}    
    }
    
    public class Summary{
        public String loanId {get;set;}
        public String loanDisplayId {get;set;}
        public String amountDue {get;set;}
        public String amountDue30Days {get;set;}
        public String DaysPastDue {get;set;}
        public String nextPaymentDate {get;set;}
        public String nextPaymentAmount {get;set;}
        public String principalBalance {get;set;}
        public String currentPayoff {get;set;}
    }
    
    public class Collateral{
        public CollateralSummary summary {get;set;}
    }
    
    public class CollateralSummary{
        public String VIN {get;set;}
    }
    
    public class Payment{
        public String id {get;set;}
        public String paymentid {get;set;}
    }
}