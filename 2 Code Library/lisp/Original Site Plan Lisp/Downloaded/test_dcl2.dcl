test_dcl2
 
: dialog
 
{
 
label = "Test Dialog No 2";
		
	: edit_box
	{
	label = "Enter Your Name :";
	mnemonic = "N";
	key = "name";
	alignment = centered;
	edit_limit = 30;
	edit_width = 30;
	}
 
	: edit_box
	{
	label = "Enter Your Age :";
	mnemonic = "A";
	key = "age";
	alignment = centered;
	edit_limit = 3;
	edit_width = 3;
	value = "";
	}
 
	: button	
	{
	key = "accept";
	label = "OK";
	is_default = true;
	fixed_width = true;
	alignment = centered;
	}
 
	: errtile
	{
	width = 34;
	}
}