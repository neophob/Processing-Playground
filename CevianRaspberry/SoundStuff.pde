/*
ripped from http://www.openprocessing.org/sketch/101123
http://mikfielding.com/EQ_Sound_Frequencies.shtml
http://www.offbeat.co.uk/wp-content/uploads/2012/06/eq-chart.pdf

range 0 = Freq: 0 Hz - 21 Hz indexes: 0-1
range 1 = Freq: 21 Hz - 43 Hz indexes: 1-2
range 2 = Freq: 43 Hz - 86 Hz indexes: 2-4                 << The 1st octave is the sub-bass of the “feel” of the bass, gives a sense of power, felt more than heard
range 3 = Freq: 86 Hz - 172 Hz indexes: 4-8                << the boom frequency
range 4 = Freq: 172 Hz - 344 Hz indexes: 8-16              << UPPER BASS BAND160 - 300(warmth, or a muddy, woody sound. fundamental for snare, toms,guitars, male vox)
range 5 = Freq: 344 Hz - 689 Hz indexes: 16-32
range 6 = Freq: 689 Hz - 1378 Hz indexes: 32-64
range 7 = Freq: 1378 Hz - 2756 Hz indexes: 64-128
range 8 = Freq: 2756 Hz - 5512 Hz indexes: 128-256         << TOM, Kick Drum Attacks
range 9 = Freq: 5512 Hz - 11025 Hz indexes: 256-512        << Snare attack
range 10 = Freq: 11025 Hz - 22050 Hz indexes: 512-1024

*/

class BandData {
  //float lastBandEnergy;
  float currentBandEnergy;
  float maxBandEnergy;
  boolean boom;
  int boomBounceProtect;
  int loops;
}

class SoundAnalyzer {
  private int BANDS = 6;
  private float AVG_TRIGGER_MINIMUM = 5.5f;  
  //if lower than minimum energy, ignore band energy
  private float MINIMUM_ENERGY= 10f;
  //wait n iterations to change bounce state
  private int BOUNCE_PROTECT = 2;
  
  private BandData[] band;
  
  private Minim minim;
  private AudioPlayer player;
  private FFT fft;
  
  private int numZones = 0;

/* if the number for fft_band_per_oct is higher than 1, it will still result in 9 octaves / bands
 because the number of bands you get is equal to log2 of bufferSize ie. log2(512) = 9 */
 
// 512 returns 86hz bandwidth which allows 9 octaves / bands
// 1024 returns 43hz bandwidth which allows 10 octaves / bands
// 2048 returns 21hz bandwidth which allows 11 octaves / bands
  private int FFT_BASE_FREQ = 21; // size of the smallest octave to use (in Hz) so we calculate averages based on a miminum octave width of 86 Hz
  private int FFT_BAND_PER_OCT = 1; // how many bands to split each octave into? in this case split each octave into 1 band
  
  private final int SAMPLE_RATE = 44100;
  private final int BUFFER_SIZE = 2048;


  public SoundAnalyzer(PApplet parent, String filename) {
    minim = new Minim(parent);
    player = minim.loadFile(filename, BUFFER_SIZE);
    
    fft = new FFT(BUFFER_SIZE, SAMPLE_RATE);
//    fft = new FFT(player.bufferSize(), player.sampleRate());
    fft.logAverages(FFT_BASE_FREQ, FFT_BAND_PER_OCT); // results in 9 bands
 
    fft.window(FFT.HAMMING);
    numZones = fft.avgSize(); // avgSize() returns the number of averages currently being calculated
    band = new BandData[fft.avgSize()];
   for (int i=0; i<fft.avgSize(); i++) {
     band[i] = new BandData();
   }
  }
  
  ///////////////////////////////////////////////
  void play() {
    player.play();
  }

  ///////////////////////////////////////////////
  void closeMinim() {
    player.pause();
    player.close(); // always close Minim audio classes when you are finished with them
    minim.stop(); // always stop Minim before exiting    
  }
  
  ///////////////////////////////////////////////
  void soundProcess() {
    fft.forward(player.mix);
   
    for (int i = 0; i < BANDS; i++) { // 9 bands / zones / averages
      band[i].currentBandEnergy = getBandEnergy(i);
      
      if (band[i].boomBounceProtect==0) {
        band[i].boom = false;
      }
      
      if (band[i].currentBandEnergy < MINIMUM_ENERGY || band[i].boomBounceProtect>0) {
        if (band[i].boomBounceProtect>0) {
          band[i].boomBounceProtect--;
        }
        band[i].maxBandEnergy -= 2.9f;
        if (band[i].maxBandEnergy < 0.1f) band[i].maxBandEnergy=0.1f;
        continue;
      }      
      if (band[i].boomBounceProtect>0) {
        band[i].boomBounceProtect--;
      }

      if (band[i].currentBandEnergy > band[i].maxBandEnergy) {
        float mul = random(5)+COLOR_LOOP_MUL;
        band[i].loops = int(mul*band[i].currentBandEnergy / band[i].maxBandEnergy);
        if (band[i].loops>COLOR_LOOP_MUL_MAX) {
          band[i].loops=COLOR_LOOP_MUL_MAX;
          //println("band[i].currentBandEnergy: "+band[i].currentBandEnergy);
        }
        band[i].boom = true;  
        band[i].boomBounceProtect = BOUNCE_PROTECT;   
        band[i].maxBandEnergy = band[i].currentBandEnergy;
      } else {
        band[i].maxBandEnergy -= 2.9f;
        if (band[i].maxBandEnergy < 0.1f) band[i].maxBandEnergy=0.1f;
      }
      
      //println(i+": current: "+band[i].currentBandEnergy+" max: "+ band[i].maxBandEnergy);

      // ***** THIS IS WHERE WE CAN ISOLATE SPECIFIC FREQUENCIES. THERE ARE 9 FREQUENCY BANDS (0 - 8) ***** //
      //canvas.rect(i*15, height/2, 15, -band[i].currentBandEnergy);
    }
  }

  void drawValues(int alpha) {
    int glitchOfsX = textDisplay.getGx();
    int glitchOfsY = 210+textDisplay.getGy();
    fill(255, alpha);

    for (int i = 0; i < BANDS; i++) {
      text(band[i].currentBandEnergy+"", glitchOfsX, glitchOfsY+i*50);
    }
  }
  
  void drawEq() {            
    for (int i = 0; i < BANDS; i++) {
      fill(110+i*10,255);      
      rect(i*50, height, 50, -band[i].currentBandEnergy);
      if (band[i].boom) {
        fill(255,0,0,255);
        rect(i*50+25, height, 25, -20);        
      }
      fill(0,255,0,128);
      rect(i*50, height, 10, -band[i].maxBandEnergy);
      
      text(band[i].currentBandEnergy+"", 100, i*50);
    }
  }
  

  private float getBandEnergy(int i) {
      int highZone = numZones - 1;

      float average = fft.getAvg(i); // return the value of the requested average band, ie. returns averages[i]

      float avg = 0;
      int lowFreq;
      if ( i == 0 ) {
        lowFreq = 0;
      } else {
        lowFreq = (int)((SAMPLE_RATE/2) / (float)Math.pow(2, numZones - i)); // 0, 86, 172, 344, 689, 1378, 2756, 5512, 11025
      }
      int hiFreq = (int)((SAMPLE_RATE/2) / (float)Math.pow(2, highZone - i)); // 86, 172, 344, 689, 1378, 2756, 5512, 11025, 22050
 
      // ***** ASK FOR THE INDEX OF lowFreq & hiFreq USING freqToIndex ***** //
 
      // freqToIndex returns the index of the frequency band that contains the requested frequency
      int lowBound = fft.freqToIndex(lowFreq);
      int hiBound = fft.freqToIndex(hiFreq);
 
      // ***** NB: THE BELOW PRINTS THE RANGES 0 - 8, THEIR RESPECTIVE FREQENCIES & INDEXES ***** //
      for (int j = lowBound; j <= hiBound; j++) { // j is 0 - 256
        float spectrum = fft.getBand(j); // return the amplitude of the requested frequency band, ie. returns spectrum[offset]
        avg += spectrum; // avg += spectrum[j];
      }
 
      avg /= (hiBound - lowBound + 1);
      //average = avg; // averages[i] = avg;
      //println("range " + i + " = " + "Freq: " + lowFreq + " Hz - " + hiFreq + " Hz " + "indexes: " + lowBound + "-" + hiBound+" avg: "+average);
      return avg;    
  }
  
  public BandData getBandData(int bandNr) {
    return band[bandNr];
  }  
  
  public FFT getFft() {
    return fft;
  }
}


