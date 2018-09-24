if (MIDIClient.initialized,
	{},
	{
		MIDIClient.init;
		MIDIIn.connect(0, MIDIIn.findPort("IAC Driver", "Bus 1"));
		MIDISyncClock.init(0, 0);
	}
);