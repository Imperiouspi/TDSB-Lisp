#For accessibility procedure. Opens and place each folder window for each site
Add-Type @"
	using System;
	using System.Text;
	using System.Runtime.InteropServices;
	using System.Threading;

	public class Window {
		public static String num = "0";
		[DllImport("user32.dll")]
		[return: MarshalAs(UnmanagedType.Bool)]
		public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

		[DllImport("User32.dll")]
		public extern static bool MoveWindow(IntPtr handle, int x, int y, int width, int height, bool redraw);

		public static void OpenFolder(String path, String passednum){
			System.Diagnostics.Process.Start("explorer.exe", path);
			Thread.Sleep(1000);
		}

		public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);
		[DllImport("user32.dll", CharSet = CharSet.Unicode)]
		public static extern int GetWindowText(IntPtr hWnd, StringBuilder strText, int maxCount);
		[DllImport("user32.dll", CharSet = CharSet.Unicode)]
		public static extern int GetWindowTextLength(IntPtr hWnd);
		[DllImport("user32.dll")]
		public static extern bool EnumWindows(EnumWindowsProc enumProc, IntPtr lParam);
		[DllImport("user32.dll")]
		public static extern bool IsWindowVisible(IntPtr hWnd);
		public static bool EnumTheWindows(IntPtr hWnd, IntPtr lParam)
		{
			int size = GetWindowTextLength(hWnd);
			StringBuilder sb = new StringBuilder(size);
			GetWindowText(hWnd, sb, size);
			Console.WriteLine(sb.ToString());
			if(sb.ToString().Contains(num)){
				if(sb.ToString().Contains("sdf")){
					MoveWindow(hWnd, 2596, 16, 574, 463, true);
				}
				else{
					MoveWindow(hWnd, 2596, 532, 574, 463, true);
				}
			}

			return true;
		}
		public static void en(String pnum)
		{
			Window.num = pnum;
			EnumWindows(new EnumWindowsProc(EnumTheWindows), IntPtr.Zero);
		}
	}
	public struct RECT
	{
		public int Left;        // x position of upper-left corner
		public int Top;         // y position of upper-left corner
		public int Right;       // x position of lower-right corner
		public int Bottom;      // y position of lower-right corner
	}
"@

$MasterPath = '\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files'
$folderlist = (gci '\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files' | ?{ $_.PSIsContainer -and -not $_.name.contains("0000")} | sort-object -property name)
$lastdone = (gci '\\TDSBSHARES\facilities_silo\Facility-Services\Standards-Comp-Envir\Staff\Record Drawing Master Files\0000 sdf\Accessibility' | ?{-not $_.PSIsContainer} | ?{$_.name -like "*.dwg"} | sort-object -property name)
$lastnum = ($lastdone[-1].name -split '-')[0]
$rect = New-Object RECT
$i=0
while ($i -lt $folderlist.length){
	$folder = $folderlist[$i]
	if ($folder.name.contains(($file.name -split '-')[0])){
		$num = ($folder.name -split ' - ')[0]

		#Manual Move
		if(($oldnum -ne $num) -and ($num -ge $lastnum)){
			#close old windows
			$a = (New-Object -comObject Shell.Application).Windows() | ?{ $_.FullName -ne $null} | ? { ($_.FullName.toLower() -like ('*explorer.exe')) -and ($_.LocationName -like "*$oldnum sdf")}
			if ($a -ne $null){
				$a | % {$_.Quit()}
			}
			$a = (New-Object -comObject Shell.Application).Windows() | ?{ $_.FullName -ne $null} | ? { ($_.FullName.toLower() -like ('*explorer.exe')) -and ($_.LocationName -like "*$oldnum")}
			if ($a -ne $null){
				$a | % {$_.Quit()}
			}
			#open new ones
			[Window]::OpenFolder("$MasterPath\$folder\$num", "$num")
			[Window]::OpenFolder("$MasterPath\$folder\$num sdf", "$num")
			$a1 = (New-Object -comObject Shell.Application).Windows() | ?{ $_.FullName -ne $null} | ? { ($_.FullName.toLower() -like ('*explorer.exe')) -and ($_.LocationName -like "*$num sdf")}
			$a2 = (New-Object -comObject Shell.Application).Windows() | ?{ $_.FullName -ne $null} | ? { ($_.FullName.toLower() -like ('*explorer.exe')) -and ($_.LocationName -like "*$num")}
			[Window]::MoveWindow($a2.hwnd, 2596, 532, 574, 463, $true)
			[Window]::MoveWindow($a1.hwnd, 2596, 16, 574, 463, $true)
			
			Write-Host "$num opened - Press any key to continue... (b for back)"
			$input = read-host
			$keyoption = 'b'
			if($keyoption -contains $keypress.character){
				$i--
			} else {
				$i++
			}
		}
		else{
			Write-Host "Skipping $num"
			$i++
		}
		$oldnum = $num
	}
}

