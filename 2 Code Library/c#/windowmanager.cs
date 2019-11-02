using System;
using System.Text;
using System.Runtime.InteropServices;

public class Window {
	public static int num = "0";
	[DllImport("user32.dll")]
	[return: MarshalAs(UnmanagedType.Bool)]
	public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

	[DllImport("User32.dll")]
	public extern static bool MoveWindow(IntPtr handle, int x, int y, int width, int height, bool redraw);

	public static void OpenFolder(String path, int passednum){
		System.Diagnostics.Process.Start("explorer.exe", path);
		Window.num = passednum;
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
		if (size++ > 0 && IsWindowVisible(hWnd))
		{
			StringBuilder sb = new StringBuilder(size);
			GetWindowText(hWnd, sb, size);
			if(sb.ToString().Contains(num)){
				if(sb.ToString().Contains("sdf")){
					MoveWindow(hWnd, 2596, 16, 574, 463, true);
				}
				else{
					MoveWindow(hWnd, 2596, 532, 574, 463, true);
				}
			}
		}
		return true;
	}
	public static void en(int pnum)
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