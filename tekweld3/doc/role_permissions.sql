//This sql is to insert main menu to a role. role id is hardcoded. Also give the moodule_id for the moodule.
//vendor PO 		- 3; 
//vendor payable 	- 4
//customer po		- 5
//customer receivable - 7
//setup				- 9

//Roles
//vendor 	- 1
//customer 	-2
//general 	-3

insert into jewe1112.role_permissions 
	(company_id ,
	created_by ,
	updated_by ,
	created_at ,
	updated_at ,
	update_flag ,
	trans_flag ,
	lock_version ,
	role_id ,
	document_id ,
	menu_id ,
	moodule_id ,
	create_permission ,
	modify_permission ,
	view_permission )
select company_id,
		620,
		45,
		'1990-01-01 00:00:00',
		'1990-01-01 00:00:00',
		'A',
		'A',
		0,
		101,
		0,
		id,
		moodule_id,
		'Y',
		'Y', 
		'Y'
from jewe1112.menus
where menu_type = 'M'
	and moodule_id = 113;