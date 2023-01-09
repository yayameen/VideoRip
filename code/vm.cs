using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Threading.Tasks;


namespace VideoRip
{
    
    public class Vm : INotifyPropertyChanged
    {
        [DllImport("User32.dll", CallingConvention = CallingConvention.StdCall, SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        private static extern bool ShowWindow([In] IntPtr hWnd, [In] int nCmdShow);


        private string _year;
        private string _specialInfo;
        private string _episodeLength;
        private string _encodeSetting;
        private string _mediaType;
        private bool _multiTitle = false;
        private string _title;
        private bool _readingTitle = false;
        private string _filmLength;
        private string _tempRipDirectory;
        private string _tempConvertDirectory;
		private string _season;
        private string _videoOutputLocation;
        private string _langCode;
        private bool _isBonusDisc;

        private Dictionary<string, string> _parameters = 
            new Dictionary<string, string>(StringComparer.CurrentCultureIgnoreCase);

        private string _yearError;
        private string _episodeLengthError;
        private string _mediaTypeError;
        private string _specialInfoError;
        private string _encodeSettingError;
        public string FilmLengthError { get; set; }
		public string TitleError { get; set; }
		public string SeasonError{ get; set;}
        public string LangCodeError { get; set; }


        public void AddParameter(string name, string value)
        {
            _parameters[name] = value;
        }

        public bool RemoveParameter(string name)
        {
            return _parameters.Remove(name);
        }

        public void ClearParameters()
        {
            _parameters.Clear();
        }

        public string LangCode
        {
            get { return _langCode; }
            set
            {
                LangCodeError = String.Empty;
                var cultures = CultureInfo.GetCultures(CultureTypes.NeutralCultures);
                string text = value;
                if (!String.IsNullOrEmpty(value) && value != _langCode)
                {
                    if (value.Length != 3)
                    {
                        var match = cultures.FirstOrDefault(c => c.DisplayName == value);
                        if (match == null)
                        { LangCodeError = "Language code must be 3 letters"; }
                        else
                        {
                            text = match.ThreeLetterISOLanguageName;
                            _langCode = text;
                            FireChanged(nameof(LangCode));
                        }
                    }
                    else
                    {
                        text = value.ToLowerInvariant();
                        bool found = cultures.Any(c => c.ThreeLetterISOLanguageName == text);
                        if (!found)
                        {
                            LangCodeError = "Language Code not found";
                        }
                        else
                        {
                            _langCode = text;
                            FireChanged(nameof(LangCode));
                        }
                    }
                }
                
            }
        }
		
		public string Season {
			get { return _season; }
			set 
			{
				ValidateSeason(value);
				if(String.IsNullOrWhiteSpace(SeasonError))
				{
					_season = value;
					FireChanged(nameof(Season));
				}
			}			
		}
		
		void ValidateSeason(string text)
		{
			SeasonError = "";
			if (!String.IsNullOrEmpty(text))
            {
                if (text.Any(c => !Char.IsDigit(c)))
                {
                    SeasonError = "Not a number";
                }
				
				int temp;
				if(!Int32.TryParse(text, out temp))
				{
					SeasonError = "Invalid Number";
				}
			}
		}

        public string Year {
            get => _year;
            set {
                ValidateYear(value);
                if (String.IsNullOrEmpty(YearError))
                {
                    _year = value;
                    FireChanged(nameof(Year));
                }
            }
        }

        public string YearError {
            get => _yearError;
            set => _yearError = value;
        }

        public string EpisodeLength
        {
            get => _episodeLength;
            set {
                ValidateEpisodeLength(value);
                if (String.IsNullOrEmpty(EpisodeLengthError))
                {
                    _episodeLength = value;
                    FireChanged(nameof(EpisodeLength));
                }
            }
        }

        public string EpisodeLengthError {
            get => _episodeLengthError;
            set => _episodeLengthError = value; }

        public string MediaType
        {
            get => _mediaType;
            set {
                ValidateMediaType(value);
                if (String.IsNullOrEmpty(MediaTypeError))
                {
                    _mediaType = value;
                    FireChanged(nameof(MediaType));
                }
            }
        }

        public string MediaTypeError { get => _mediaTypeError; set => _mediaTypeError = value; }

        public string SpecialInfo
        {
            get => _specialInfo;
            set {
                ValidateSpecialInfo(value);
                if (String.IsNullOrEmpty(SpecialInfoError))
                {
                    _specialInfo = value;
                    FireChanged(nameof(SpecialInfo));
                }
            }
        }

        public string SpecialInfoError { get => _specialInfoError; set => _specialInfoError = value; }
        public string EncodeSetting
        {
            get => _encodeSetting;
            set { _encodeSetting = value;
                FireChanged(nameof(EncodeSetting));
            }
        }

        public string EncodeSettingError { get => _encodeSettingError; set => _encodeSettingError = value; }

        public bool MultiTitle
        {
            get => _multiTitle;
            set {
                _multiTitle = value;
                FireChanged(nameof(MultiTitle));
            }
        }

        public string Title
        {
            get => _title;
            set {
                TitleError = ValidateFilename(value);
                if (String.IsNullOrEmpty(TitleError))
                {
                    _title = value;
                    FireChanged(nameof(Title));
                }
            }
        }

        public bool ReadingTitle
        {
            get => _readingTitle;
            set {                
                _readingTitle = value;
                FireChanged(nameof(ReadingTitle));
            }
        }

        public string FilmLength
        {
            get => _filmLength;
            set {
                string text = value;
                ValidateLength(ref text);
                if (String.IsNullOrEmpty(FilmLengthError))
                {
                    _filmLength = text;
                    FireChanged(nameof(FilmLength));
                }
            }
        }

        public string TempRipDirectory
        {
            get => _tempRipDirectory;
            set { _tempRipDirectory = value;
                FireChanged(nameof(TempRipDirectory));
            }
        }
        public string TempConvertDirectory
        {
            get => _tempConvertDirectory;
            set { _tempConvertDirectory = value;
                FireChanged(nameof(TempRipDirectory));
            }
        }

        public string VideoOutputLocationError { get; set; }

        public string VideoOutputLocation
        {
            get => _videoOutputLocation;
            set
            {
                _videoOutputLocation = value;
            }
        }

        public bool IsBonusDisc { get => _isBonusDisc; set => _isBonusDisc = value; }

        public void ValidateEncodeSetting(string text)
        {
            EncodeSettingError = ValidateFilename(text);
        }

        public void ValidateSpecialInfo(string text)
        {
            SpecialInfoError = ValidateFilename(text);
        }

        public string ValidateFilename(string text)
        {
            string error = String.Empty;

            char[] illegal = { ':', '\\', '/', '(', ')', '<', '>', '"', '!', '|', '*', '?' };
            int index = text.IndexOfAny(illegal);
            if ( index > -1)
            {
                error = "Illegal character '" + text[index] + "'";
            }

            char[] illegal2 = { '\t', '\n', '\r', '\f', '\v' };
            index = text.IndexOfAny(illegal2);
            if (index > -1)
            {
                error = "Illegal white space character";
            }
            else if(text.Any(c => c < 32))
            {
                error = "Illegal unprintable character";
            }

            if (text.Length > 64)
            {
                error = "Longer than 64 characters";
            }
            return error;
        }

        public void ValidateEpisodeLength(string text)
        {
            EpisodeLengthError = String.Empty;
            if (!String.IsNullOrEmpty(text) &&
                (text.Length > 2 || text.Any(c => !char.IsDigit(c))))
            {
                EpisodeLengthError = "Invalid Episode Length. Must be 30 or 60";
            }
        }

        public void ValidateMediaType(string text)
        {
            MediaTypeError = String.Empty;
            if (text != "TV" &&
                text != "FILM" &&
                text != "")
            {
                MediaTypeError = "Invalid Media Type. Must be TV or FILM";
            }
        }

        public void ValidateLength(ref string text)
        {
            FilmLengthError = String.Empty;

            if (!String.IsNullOrEmpty(text))
            {
                if(text.Any( c => c == ':'))
                {
                    TimeSpan ts;
                    if( TimeSpan.TryParse(text, out ts))
                    {
                        text = ts.TotalMinutes.ToString("G");
                    }
                    else
                    {
                        FilmLengthError = "Invalid format";
                    }
                }
                if (text.Any(c => !Char.IsDigit(c)))
                {
                    FilmLengthError = "Invalid Number";
                }

                int length = 0;
                if (!Int32.TryParse(text, out length))
                {
                    FilmLengthError = "Invalid Time";
                }
                if (length < 8)
                {
                    FilmLengthError = "Too short. Must be at least 8 minutes";
                }
                if (length > 360)
                {
                    FilmLengthError = "Too long. Must be less than 360 minutes";
                }
            }
        }

        public void ValidateYear(string text)
        {
            _yearError = String.Empty;            

            if (!String.IsNullOrEmpty(text))
            {
                if (text.Any(c => !Char.IsDigit(c)))
                {
                    _yearError = "Invalid Number";
                }

                int year = 0;
                if (!Int32.TryParse(text, out year))
                {
                    _yearError = "Invalid Year";
                }
                if (year < 1900 || year > (DateTime.Now.Year + 10))
                {
                    _yearError = "Invalid Date";
                }
            }
        }

        public void FireChanged(string name)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
        }

        public event PropertyChangedEventHandler PropertyChanged;

        public void Start()
        {
            ProcessStartInfo startInfo = new ProcessStartInfo("cmd.exe");
            startInfo.WindowStyle = ProcessWindowStyle.Minimized;
            startInfo.Arguments = "/c rip.bat";
            startInfo.UseShellExecute = false;
            SetEnvironmentVars(startInfo);

            var process = Process.Start(startInfo);

            try
            {
                Thread.Sleep(2000);
                if (process.MainWindowHandle != IntPtr.Zero)
                {
                    ShowWindow(process.MainWindowHandle, 6);
                }
            }
            catch { }

        }

        private void SetEnvironmentVars(ProcessStartInfo startInfo)
        {
            if (IsBonusDisc)
            {
                Set(startInfo.EnvironmentVariables, "isBonusDisc", "TRUE");
            }
            if (!String.IsNullOrWhiteSpace(_year))
            {
                Set(startInfo.EnvironmentVariables, "titleYear", _year);
            }
            if (!String.IsNullOrWhiteSpace(_specialInfo))
            {
                Set(startInfo.EnvironmentVariables, "titleSpecialInfo", _specialInfo);
            }
            if (!String.IsNullOrWhiteSpace(_episodeLength))
            {
                Set(startInfo.EnvironmentVariables, "EpisodeLength", _episodeLength);
            }
            if (!String.IsNullOrWhiteSpace(_encodeSetting))
            {
                Set(startInfo.EnvironmentVariables, "preset", _encodeSetting);
            }
            if (!String.IsNullOrWhiteSpace(_mediaType))
            {
                Set(startInfo.EnvironmentVariables, "mediaType", _mediaType);
            }
            if (_multiTitle)
            {
                Set(startInfo.EnvironmentVariables, "multiTitle", "TRUE");
            }
            if (!String.IsNullOrWhiteSpace(Title))
            {
                Set(startInfo.EnvironmentVariables, "userTitle", Title);
            }
            if (!String.IsNullOrWhiteSpace(FilmLength))
            {
                int length;
                if (Int32.TryParse(FilmLength, out length))
                {
                    string text = (length / 60).ToString("G");
                    text += ":";
                    text += (length % 60).ToString("D2");
                    Set(startInfo.EnvironmentVariables, "userLength", text);
                }
                else if (FilmLength.Contains(':'))
                {
                    string text = FilmLength + ":";
                    Set(startInfo.EnvironmentVariables, "userLength", text);
                }
            }
            if (!string.IsNullOrWhiteSpace(TempConvertDirectory))
            {
                string tempConvertDirectory = TempConvertDirectory;
                Directory.CreateDirectory(tempConvertDirectory);
                if (!tempConvertDirectory.EndsWith("\\"))
                {
                    tempConvertDirectory += "\\";
                }
                Set(startInfo.EnvironmentVariables, "tempConvertDir", tempConvertDirectory);
            }
            if (!string.IsNullOrWhiteSpace(TempRipDirectory))
            {
                string tempRipDirectory = TempRipDirectory;
                Directory.CreateDirectory(tempRipDirectory);
                if (!tempRipDirectory.EndsWith("\\"))
                {
                    tempRipDirectory += "\\";
                }
                Set(startInfo.EnvironmentVariables, "tempVidDir", tempRipDirectory);
            }
            if (!String.IsNullOrWhiteSpace(Season))
            {
                string season = Season;
                if (season.Length == 1)
                {
                    season = "0" + season;
                }
                Set(startInfo.EnvironmentVariables, "seasonNum", season);
            }
            if (!String.IsNullOrWhiteSpace(LangCode))
            {
                Set(startInfo.EnvironmentVariables, "lang", LangCode);
            }

            if (!String.IsNullOrWhiteSpace(VideoOutputLocation))
            {
                Directory.CreateDirectory(VideoOutputLocation);
                Directory.CreateDirectory(Path.Combine(VideoOutputLocation, "TV"));
                Directory.CreateDirectory(Path.Combine(VideoOutputLocation, "Films"));
                Directory.CreateDirectory(VideoOutputLocation);
                Set(startInfo.EnvironmentVariables, "TvFolder", Path.Combine(VideoOutputLocation, "TV") + "\\");
                Set(startInfo.EnvironmentVariables, "FilmFolder", Path.Combine(VideoOutputLocation, "Films") + "\\");
            }

            foreach (var pair in _parameters)
            {
                startInfo.EnvironmentVariables[pair.Key] = pair.Value;
            }
        }

        public void Set(StringDictionary dict, string key, string value)
        {
            if(dict.ContainsKey(key))
            {
                dict.Remove(key);
            }
            dict.Add(key, value);
        }

        public void ReadTitle()
        {
            ProcessStartInfo startInfo = new ProcessStartInfo("cmd.exe");
            startInfo.WindowStyle = ProcessWindowStyle.Minimized;
            startInfo.Arguments = "/c readDiscInfo.bat";
            startInfo.UseShellExecute = false;
            ReadingTitle = true;
            try
            {
                if (!String.IsNullOrWhiteSpace(_mediaType))
                {
                    startInfo.EnvironmentVariables.Add("mediaType", _mediaType);
                }

                
                var process = Process.Start(startInfo);
                process.EnableRaisingEvents = true;
                process.Exited += Process_Exited;

                Thread.Sleep(1000);
                try
                {
                    if (process.MainWindowHandle != IntPtr.Zero)
                    {
                        ShowWindow(process.MainWindowHandle, 6);
                    }
                }
                catch { }

                if(process.HasExited)
                {
                    Process_Exited(null, null);
                }
            }
            catch
            {
                ReadingTitle = false;
            }
        }

        private void Process_Exited(object sender, EventArgs e)
        {
            if (ReadingTitle)
            {
                ReadingTitle = false;
                try
                {
                    using (var stream = File.OpenText("discTitle.txt"))
                    {
                        string title = stream.ReadLine();
                        if (!String.IsNullOrWhiteSpace(title))
                        {
                            Title = title.Replace('_', ' ');
                        }
                        else
                        {
                            Title = "Blank";
                        }
                    }
                }
                catch (Exception ex)
                {
                    Title = "Error";
                }
            }
        }

        public void Clean()
        {
            ProcessStartInfo startInfo = new ProcessStartInfo("cmd.exe");
            startInfo.WindowStyle = ProcessWindowStyle.Minimized;
            startInfo.Arguments = "/c clean.bat";
            startInfo.UseShellExecute = false;
            SetEnvironmentVars(startInfo);
            ReadingTitle = false;
            try
            {
                var process = Process.Start(startInfo);
            }
            catch
            {
                
            }
        }
    }
}
