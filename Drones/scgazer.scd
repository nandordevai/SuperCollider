(
~wt = Array.fill(90, {
	var i = rrand (90, 20);
	Env(
		levels: (({ rrand(0.0, 1.0) } ! (i - 1)) * [1, -1]).scramble,
		times: { rrand(1, 20) } ! i,
        curve: \sine
	).asSignal(1024)
    .asWavetable;
});

~vbuf = Buffer.allocConsecutive(90, s, 2048);
~vbuf.do({| buf, i |
	buf.loadCollection(~wt[i]);
});

SynthDef.new(\stargazer, {

    arg amp=1, out=0, pan=0.0, freq=440, gain=(-1.0), wave=0, sub=0, detune=1,
    mix=(-1.0), freq1=880, freq2=880, res1=0.0, res2=0.0, alias=44100, redux=24,
    rate1 = 10, rate2 = 10, rate3 = 10, depth1 = 1, depth2 = 1, depth3 = 1,
    lfo1type1 = 0, 	lfo1type2 = 0, 	lfo1type3 = 0;

    var sig, detuned, pitch, lfo1, lfo2, lfo3, filter1, filter2;


    lfo1=Select.kr(lfo1type1, [LFTri.kr(rate1), LFSaw.kr(rate1), LFPulse.kr(rate1)]);
    lfo2=Select.kr(lfo1type2, [LFTri.kr(rate2), LFSaw.kr(rate2), LFPulse.kr(rate2)]);
    lfo3=Select.kr(lfo1type3, [LFTri.kr(rate3), LFSaw.kr(rate3), LFPulse.kr(rate3)]);
    detuned = Select.ar(sub, [VOsc.ar(wave, freq*detune), VOsc.ar(wave, (freq*0.5)*detune)]);

    wave = ~vbuf[0].bufnum + wave;
    sig = VOsc.ar(wave, freq);
    sig = XFade2.ar(sig, detuned, mix);
    filter1 = MoogLadder.ar(sig, freq1*lfo1.range(1, depth1), res1);
    sig = Decimator.ar(filter1, alias, redux);
    filter2 = MoogLadder.ar(sig, freq2*lfo2.range(1, depth2), res2);
    sig = Splay.ar(filter2);
    sig = LeakDC.ar(sig);
    sig = XFade2.ar(sig, sig.clip, gain);
    sig=sig*amp*lfo3.range(1, depth3);
    sig = Limiter.ar(sig, 0.8);

    Out.ar(out, sig)

}).add;

x=Synth(\stargazer,
    [
        \freq, 55.midicps, //Pitch
        \wave, 69, //waveform selector 0 to 89 waveform
        \detune, 1.midiratio, //detune parameter of the second oscillator
        \sub, 1, // 1 takes detune one octave lower, 0 for using detune as it is
        \mix, 0, // Mix for 2 oscillator. -1 is 1st oscillator and 1 for the 2nd oscillator only 0 is the middle
        \freq1, 1000, // Cutoff frequency for the 1st filter
        \lfo1type1, 0, // LFO of 1st filter choose between 3 waveforms 0 for Triangle, 1 for Saw, 2 for Pulse
        \rate1, 1, // Rate of 1st LFO in Hz
        \depth1, 1, // Depth of 1st LFO in Hz, 1 means no modulation, 0 is max
        \alias, 44100/8, // Sample rate reduction in Hz
        \redux, 8, // Bit rate reduction between 0-24 bits
        \freq2, 600, // Cutoff frequency for the 2nd filter
        \lfo1type2, 0, // LFO of 2nd filter choose between 3 waveforms 0 for Triangle, 1 for Saw, 2 for Pulse
        \rate2, 60, // Rate of 2nd LFO in Hz
        \depth2, 0.3, // Depth of 2nd LFO in Hz, 1 means no modulation, 0 is max
        \gain, -1, // Gain stage for distortion kinda effect -1 is clean, 1 is dirty
        \lfo1type3, 2, // LFO of amplitude choose between 3 waveforms 0 for Triangle, 1 for Saw, 2 for Pulse
        \rate3, 20, // Rate of 3rd LFO in Hz
        \depth3, 1, // Depth of 3rd LFO in Hz, 1 means no modulation, 0 is max)

]);
)
