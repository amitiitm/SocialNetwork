import com.generic.events.AddEditEvent;
import model.GenModelLocator;
import mx.controls.Alert;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance()

private function init():void
{
	dfStart_date.dataValue = ""
	dfEnd_date.dataValue = ""
	dfDue_date.dataValue = ""
}
private function handleAccountChange():void
{
		dcCRM_contact_id_activity.filterKeyValue = dcCRM_account_id_activity.dataValue
}

private function handleReminderChange(event:Event):void
{
	if(cbReminder_flag.selected)
	{
		dfReminder_date_time.text = dfReminder_date_time.currentDate();
		dfReminder_date_time.enabled = true
	}
	else
	{
		dfReminder_date_time.text = ''
		dfReminder_date_time.enabled = false
	}
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
		var recordXml:XML	= event.recordXml;
	if(dgTask.rows.children().length() == 0)
	{
		createBlankTask()
	}

	var taskXML:XML = dgTask.rows.children()[0];

	dfTrans_date.dataValue					=	taskXML["trans_date"].toString()
	tiCRM_contact_id.dataValue				= 	taskXML["crm_contact_id"].toString()
	tiCRM_account_id_task.dataValue			= 	taskXML["crm_account_id"].toString()
	tiAssigned_user_id.dataValue			= 	taskXML["assigned_user_id"].toString()
	cbSubject_task.dataValue				= 	taskXML["subject"].toString()
	tiLocation.dataValue					= 	taskXML["location"].toString()
	taDescription_task.dataValue			= 	taskXML["description"].toString()
	dfStart_date.dataValue					= 	taskXML["start_date"].toString()
	dfEnd_date.dataValue					= 	taskXML["end_date"].toString()
	dfDue_date.dataValue					= 	taskXML["due_date"].toString()
	tiDuration.dataValue					= 	taskXML["duration"].toString()
	cbPriority.dataValue					= 	taskXML["priority"].toString()
	cbStatus.dataValue						= 	taskXML["status"].toString()
	cbReminder_flag.dataValue				= 	taskXML["reminder_flag"].toString()
	dfReminder_date_time.dataValue			= 	taskXML["reminder_datetime"].toString()

	/*if(dgOpportunity.rows.children().length() == 0)
	{
		createBlankOpportunity()		
	}

	var opportunityXML:XML = dgOpportunity.rows.children()[0];

	tiOpportunity_name.dataValue			= 	opportunityXML["name"].toString()
	dfClose_date.dataValue 					= 	opportunityXML["close_date"].toString()
	tiCRM_account_id_opportunity.dataValue 	= 	opportunityXML["crm_account_id"].toString()
	cbStage.dataValue 						= 	opportunityXML["stage"].toString()
	cbOpportunity_type.dataValue 			= 	opportunityXML["opportunity_type"].toString()
	tiProbability_per.dataValue 			= 	opportunityXML["probability_per"].toString()
	cbSubject_opportunity.dataValue 		= 	opportunityXML["subject"].toString()
	tiAmount.dataValue 						= 	opportunityXML["amount"].toString()
	taDescription_opportunity.dataValue 	= 	opportunityXML["description"].toString()*/
	
	
	dcCRM_contact_id_activity.filterKeyValue = dcCRM_account_id_activity.dataValue;
	dcCRM_contact_id_activity.dataValue = recordXml.children()["crm_contact_id"];
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	if(dgTask.rows.children().length() == 0)
	{
		createBlankTask()
	}
	
	dgTask.rows.children()[0]["trans_date"]					=	dfTrans_date.dataValue
	dgTask.rows.children()[0]["crm_contact_id"]				=	dcCRM_contact_id_activity.dataValue
	dgTask.rows.children()[0]["crm_account_id"]				=	dcCRM_account_id_activity.dataValue
	dgTask.rows.children()[0]["assigned_user_id"]			=	dcPerformed_user_id_activity.dataValue
	dgTask.rows.children()[0]["subject"]					=	cbSubject_task.dataValue
	dgTask.rows.children()[0]["location"]					=	tiLocation.dataValue
	
	dgTask.rows.children()[0]["description"]				=	taDescription_task.dataValue
	dgTask.rows.children()[0]["start_date"]					=	dfStart_date.dataValue
	dgTask.rows.children()[0]["end_date"]					=	dfEnd_date.dataValue
	dgTask.rows.children()[0]["due_date"]					=	dfDue_date.dataValue
	dgTask.rows.children()[0]["duration"]					=	tiDuration.dataValue

	dgTask.rows.children()[0]["priority"]					=	cbPriority.dataValue
	dgTask.rows.children()[0]["status"]						=	cbStatus.dataValue
	dgTask.rows.children()[0]["reminder_flag"]				=	cbReminder_flag.dataValue
	dgTask.rows.children()[0]["reminder_datetime"]			=	dfReminder_date_time.dataValue
	//
	
	/*(if(dgOpportunity.rows.children().length() == 0)
	{
		createBlankOpportunity()
	}

	dgOpportunity.rows.children()[0]["name"]				=	tiOpportunity_name.dataValue
	dgOpportunity.rows.children()[0]["close_date"]			=	dfClose_date.dataValue 	
	dgOpportunity.rows.children()[0]["crm_account_id"]		=	dcCRM_account_id_activity.dataValue
	dgOpportunity.rows.children()[0]["stage"]				=	cbStage.dataValue 
	dgOpportunity.rows.children()[0]["opportunity_type"]	=	cbOpportunity_type.dataValue 

	dgOpportunity.rows.children()[0]["probability_per"]		=	tiProbability_per.dataValue  
	dgOpportunity.rows.children()[0]["subject"]				=	cbSubject_opportunity.dataValue 
	dgOpportunity.rows.children()[0]["amount"]				=	tiAmount.dataValue  
	dgOpportunity.rows.children()[0]["description"]			=	taDescription_opportunity.dataValue  */

	return 0;
}

private function createBlankTask():void
{
	dgTask.rows.appendChild(<crm_task>
								<id/>
								<trans_date/>
								<due_date/>
								<end_date/>
								<start_date/>
								<reminder_datetime/>
								<crm_account_id/>
								<assigned_user_id/>
								<crm_contact_id/>
								<duration/>
								<description/>
								<subject/>
								<status/>
								<priority/>
								<location/>
								<reminder_flag/>
							</crm_task>)		
	
}

/*private function createBlankOpportunity():void
{
	dgOpportunity.rows.appendChild(<crm_opportunity>
										<id/>
										<name/>
										<opportunity_type/>
										<stage/>
										<crm_account_id/>
										<close_date/>
										<probability_per/>
										<amount/>
										<subject/>
										<description/>										
									</crm_opportunity>)		
}*/

override protected function resetObjectEventHandler():void
{
	dfStart_date.dataValue = ""
	dfEnd_date.dataValue = ""
	dfDue_date.dataValue = ""
	
	dcCRM_contact_id_activity.filterKeyValue = "";
}