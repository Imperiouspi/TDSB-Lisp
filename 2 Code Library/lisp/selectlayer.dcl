selectlayer: dialog {
	: popup_list {
		label = "Layer";
		key = "layer_select";
		width = 50;
		value = "0";
	}
	: row{
		: button {
			label = "Label";
			mnemonic = "L";
			key = "label";
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
}