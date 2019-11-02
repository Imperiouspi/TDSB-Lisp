helper: dialog {
	:row{
		: popup_list {
			label = "Layer";
			key = "layer_select";
			width = 50;
			value = "0";
		}
		: button {
			label = "Isolate";
			key = "isolate";
			fixed_width = true;
		}
	}
	: button {
		label = "Select Objects";
		mnemonic = "s";
		key = "selectobj";
		alignment = centered;
		width = 30;
	}

	:row {
		: button {
			label = "Begin Labelling";
			mnemonic = "l";
			key = "labelobj";
			alignment = centered;
			width = 30;
		}
		: button {
			label = "Fix label";
			mnemonic = "f";
			key = "fixlabel";
			fixed_width = true;
		}
	}

	: button {
		label = "Export";
		mnemonic = "e";
		key = "export";
		alignment = centered;
		width = 30;
	}
	: row{
		: button {
			label = "Done";
			mnemonic = "D";
			key = "done";
			alignment = centered;
			fixed_width = true;
			is_default = true;
		}

		: button {
			label = "Cancel";
			key = "cancel";
			width = 12;
			fixed_width = true;
			mnemonic = "C";
			is_cancel = true;
		}
	}
	: button {
		label = "Options";
		mnemonic = "O";
		key = "options";
		alignment = centered;
		fixed_width = true;
	} 
}

optionswindow: dialog {
	:text {
		label = "options";
	}
	:row{
		: button {
			label = "< Back";
			mnemonic = "b";
			key = "back";
			is_default = true;
			alignment = centered;
			fixed_width = true;
			is_default = true;
		}

		: button {
			label = "Cancel";
			key = "cancel";
			width = 12;
			fixed_width = true;
			mnemonic = "C";
			is_cancel = true;
		}
	}
	:row{
		: popup_list {
			label = "Feature Select";
			key = "feature_select";
			width = 50;
			value = "0";
		}
	}
}

fixwindow: dialog {
	:row{
		: edit_box {
			label = "Which label?";
			key = "labelbox";
			width = "10";
		}
		: button {
			label = "Fix";
			key = "relabel";
			fixed_width = true;
		}
	}
	:row{
		: button {
			label = "< Back";
			mnemonic = "b";
			key = "back";
			is_default = true;
			alignment = centered;
			fixed_width = true;
			is_cancel = true;
		}
	}
}