fx_fadeOut(win)
{
	i := 255
	Loop, 25
	{
		i := i-10
		WinSet, Transparent, %i%, %win%
		sleep, 10
	}
}

fx_fadeIn(win)
{
	WinSet, Transparent, 0, %win% ; Gör fönstret genomskinligt
	i := 0
	Loop, 51
	{
		i := i+5
		WinSet, Transparent, %i%, %win%
		sleep, 5
	}
}