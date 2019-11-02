helper: dialog {
	:row{
		: edit_box {
			label = "Path:";
			key = "path_box";
			width = 50;
			value = "H:";
		}
		: button {
			label = "Export";
			key = "export";
			fixed_width = true;
			mnemonic = "e";
		}
	}
	:row{
		: button {
			label = "Cancel";
			key = "cancel";
			width = 12;
			fixed_width = true;
			mnemonic = "c";
			is_cancel = true;
		}
	}
}