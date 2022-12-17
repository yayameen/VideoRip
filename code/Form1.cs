using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml.Linq;

namespace VideoRip
{
    public partial class Form1 : Form
    {
        private ProcessPriorityClass _convertPriority;

        public Form1()
        {
            InitializeComponent();
            Model = new Vm();
            Model.PropertyChanged += Model_PropertyChanged;

            _lastUpdate = DateTime.MinValue;
            _lastLogUpdate = _lastUpdate;
            _convertPriority = ProcessPriorityClass.Normal;
            comboRepair.SelectedIndex = 0;
        }

        private void Model_PropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            if(e.PropertyName == "Title")
            {
                Invoke(new Action(OnViewModelTitleChanged));
            }
            else if(e.PropertyName == "ReadingTitle")
            {
                if (Model.ReadingTitle)
                {
                    Invoke(new Action(() => progressReadTitle.Style = ProgressBarStyle.Marquee));                    
                }
                else
                {
                    Invoke(new Action(() => progressReadTitle.Style = ProgressBarStyle.Blocks));                    
                }
            }
            else if(e.PropertyName == "LangCode")
            {
                Invoke(new Action(() => textBoxLanguage.Text = _vm.LangCode));
            }
        }

        private void OnViewModelTitleChanged()
        {
            string text = (textTitle.Text == "Detect") ? String.Empty : textTitle.Text;
            if (text != Model.Title)
            {
                checkTitle.Checked = true;
                textTitle.Text = Model.Title;
            }
        }

        private Vm _vm;
        private DateTime _lastUpdate;
        private DateTime _lastLogUpdate;
        private float _progressNum;

        public Vm Model { get => _vm; set => _vm = value; }

        private async void btnStart_Click(object sender, EventArgs e)
        {
            _progressNum = 0;
            progressReadTitle.Style = ProgressBarStyle.Blocks;
            Model.Start();
            await SaveSettings();
        }

        private async Task SaveSettings()
        {
            try
            {
                
                string location = System.IO.Path.Combine(
                    Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
                    "VideoRip");
                XDocument xdoc = new XDocument( new XElement("videoRipSettings",
                    new XElement("Language", textBoxLanguage.Text),
                    new XElement("Log", textLog.Text),
                    new XElement("Name1", textName1.Text),
                    new XElement("Value1", textValue1.Text),
                    new XElement("Name2", textName2.Text),
                    new XElement("Value2", textValue2.Text),
                    new XElement("Name3", textName3.Text),
                    new XElement("Value3", textValue3.Text),
                    new XElement("OutputLocation", textOutputLocation.Text),
                    new XElement("TempConvertDir", textTempConvertDir.Text),
                    new XElement("TempRipDir", textTempRipDir.Text)));

                if (!Directory.Exists(location))
                { Directory.CreateDirectory(location); }
                location = System.IO.Path.Combine(location, "settings.xml");
                if (File.Exists(location))
                {
                    File.Delete(location);
                }
                var xml = xdoc.ToString();

                using (var sw = new StreamWriter(location))
                {
                    await sw.WriteAsync(xml);
                }
            }
            catch(Exception ex) { }
        }

        private void ReadSettings()
        {
            try
            {
                string location = System.IO.Path.Combine(
                    Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
                    "VideoRip");
                if (Directory.Exists(location))
                {
                    location = System.IO.Path.Combine(location, "settings.xml");
                    if (File.Exists(location))
                    {
                        var xdoc = XDocument.Load(location);

                        var root = xdoc.Element("videoRipSettings");
                        if(root != null)
                        {
                            try { textBoxLanguage.Text = root.Element("Language")?.Value ?? "";
                                
                            } catch { }
                            try
                            { textLog.Text = root.Element("Log")?.Value ?? "";
                            }
                            catch { }
                            try { textName1.Text = root.Element("Name1")?.Value ?? ""; } catch { }
                            try { textValue1.Text = root.Element("Value1")?.Value ?? ""; } catch { }
                            try{ textName2.Text = root.Element("Name2")?.Value ?? ""; } catch { }
                            try{ textValue2.Text = root.Element("Value2")?.Value ?? ""; } catch { }
                            try {textName3.Text = root.Element("Name3")?.Value ?? ""; } catch { }
                            try { textValue3.Text = root.Element("Value3")?.Value ?? ""; } catch { }
                            try { textOutputLocation.Text = root.Element("OutputLocation")?.Value ?? ""; } catch { }
                            try { textTempConvertDir.Text = root.Element("TempConvertDir")?.Value ?? ""; } catch { }
                            try
                            { textTempRipDir.Text = root.Element("TempRipDir")?.Value ?? ""; }
                            catch { }

                        }
                    }
                }
            }
            catch (Exception ex) { }
        }

        private void textYear_TextChanged(object sender, EventArgs e)
        {
            try
            {
                if (textYear.Text.Length == 4 ||
                    textYear.Text.Length == 0)
                {
                    Model.Year = textYear.Text;
                }
            }
            catch { }
        }

        private void textYear_Validating(object sender, CancelEventArgs e)
        {
            if( !String.IsNullOrEmpty( Model.YearError))
            {
                e.Cancel = true;
            }
            this.errorProvider1.SetError(textYear, Model.YearError);
        }

        private void comboEpisode_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { 
                if (comboEpisode.SelectedIndex == 0)
                {
                    Model.EpisodeLength = String.Empty;
                }
                else if (comboEpisode.SelectedIndex > 0)
                {
                    Model.EpisodeLength = comboEpisode.Items[comboEpisode.SelectedIndex].ToString();
                }
            }
            catch { }
        }

        private void comboEpisode_Validating(object sender, CancelEventArgs e)
        {
            if (!String.IsNullOrEmpty(Model.EpisodeLengthError))
            {
                e.Cancel = true;                
            }
            this.errorProvider1.SetError(comboEpisode, Model.EpisodeLengthError);
        }

        private void ShowTVControls(bool show)
        {
            if (show)
            {
                Model.MediaType = "TV";
                labelEpisode.Text = "Episode Length";
            }
            else
            {
                Model.MediaType = "FILM";
                labelEpisode.Text = "Length";
            }

            comboEpisode.Enabled = show;
            textLength.Visible = !show;
            comboEpisode.Visible = show;
            textSeasonNumber.Visible = show;
            checkSeason.Visible = show;
            labelSeasonNumber.Visible = show;
        }

        private void radioFilm_CheckedChanged(object sender, EventArgs e)
        {
            if (radioFilm.Checked)
            {
                Model.MultiTitle = false;
                ShowTVControls(false);
            }
        }

        private void radioTv_CheckedChanged(object sender, EventArgs e)
        {
            if (radioTv.Checked)
            {
                Model.MultiTitle = false;
                ShowTVControls(true);
            }
            
        }

        private void radioMultiFilm_CheckedChanged(object sender, EventArgs e)
        {
            if (radioMultiFilm.Checked)
            {
                Model.MultiTitle = true;
                ShowTVControls(false);
            }
        }

        private void radioDetect_CheckedChanged(object sender, EventArgs e)
        {
            try { 
                Model.MediaType = String.Empty;
            }
            catch { }
        }

        private void textSpecialInfo_TextChanged(object sender, EventArgs e)
        {
            try { 
                Model.SpecialInfo = textSpecialInfo.Text;
            }
            catch { }
        }

        private void textSpecialInfo_Validating(object sender, CancelEventArgs e)
        {
            if (!String.IsNullOrEmpty(Model.SpecialInfoError))
            {
                e.Cancel = true;
            }
            this.errorProvider1.SetError(textSpecialInfo, Model.SpecialInfoError);
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            comboBox1.SelectedIndex = 0;
            comboEpisode.SelectedIndex = 0;
            timerStatus.Interval = 2000;
            timerStatus.Tick += StatusUpdate;
            timerStatus.Enabled = true;

            ReadSettings();
        }

        int _timerCount = 0;
        private void StatusUpdate(object sender, EventArgs args)
        {
            timerStatus.Enabled = false;
            try
            {
                string statusFile = "status.txt";
                if (File.Exists(statusFile))
                {
                    try
                    {
                        var writeTime = File.GetLastWriteTimeUtc(statusFile);
                        if (writeTime > _lastUpdate)
                        {
                            _lastUpdate = writeTime;
                            using (var stream = File.OpenText(statusFile))
                            {
                                textStatus.Text = stream.ReadToEnd();
                                textStatus.Select(textStatus.Text.Length, 0);
                                textStatus.ScrollToCaret();
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        textStatus.Text += ex.Message;
                    }
                }

                statusFile = "conversionLog.txt";
                if (File.Exists(statusFile))
                {
                    try
                    {
                        var writeTime = File.GetLastWriteTimeUtc(statusFile);
                        if (writeTime > _lastLogUpdate)
                        {
                            _lastLogUpdate = writeTime;
                            using (var stream = File.OpenText(statusFile))
                            {
                                textLog.Text = stream.ReadToEnd();
                                textLog.Select(textLog.Text.Length, 0);
                                textLog.ScrollToCaret();
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        
                    }
                }

                progressAction.Value = (int)_progressNum;

                Action a = new Action(GetProgress);
                a.BeginInvoke(null, null);

                try
                {
                    using (var stream = File.OpenText("ripProgress.txt"))
                    {
                        short progressNum = 0;
                        string num = stream.ReadLine();
                        if (Int16.TryParse(num, out progressNum))
                        {
                            progressTotal.Value = progressNum;
                        }
                    }
                }
                catch { }

                _timerCount++;

                Process handBrakeProcess = null;
                bool transcoding = false;
                if ((_timerCount % 10) == 0)
                {
                    foreach (var process in Process.GetProcesses())
                    {
                        if (process.ProcessName.IndexOf("Transcoder", StringComparison.OrdinalIgnoreCase) > -1)
                        {
                            transcoding = true;
                            if (process.PriorityClass != ProcessPriorityClass.High)
                            {
                                process.PriorityClass = ProcessPriorityClass.High;
                            }
                        }
                        else if (process.ProcessName.IndexOf("Plex Media Server", StringComparison.OrdinalIgnoreCase) > -1)
                        {
                            if (process.PriorityClass != ProcessPriorityClass.AboveNormal)
                            {
                                process.PriorityClass = ProcessPriorityClass.AboveNormal;
                            }
                        }
						else if (process.ProcessName.IndexOf("HandBrakeCLI", StringComparison.OrdinalIgnoreCase) > -1)
                        {
                            handBrakeProcess = process;
                        }
						
                    }
                }

                if(handBrakeProcess != null)
                {
                    if(transcoding && handBrakeProcess.PriorityClass != ProcessPriorityClass.BelowNormal)
                    {
                        handBrakeProcess.PriorityClass = ProcessPriorityClass.BelowNormal;
                    }
                    else if(handBrakeProcess.PriorityClass != _convertPriority)
                    {
                        handBrakeProcess.PriorityClass = _convertPriority;
                    }
                }
            }
            catch(Exception ex)
            {
                
            }
            timerStatus.Enabled = true;
        }
        
        private void GetProgress()
        {
            string progressFile = Path.Combine(Path.GetTempPath(), "Video Rip");            
            if( !String.IsNullOrWhiteSpace(_vm.TempConvertDirectory) &&
                Directory.Exists(_vm.TempConvertDirectory))
            {
                progressFile = _vm.TempConvertDirectory;
            }

            if(!Directory.Exists(progressFile))
            {
                Directory.CreateDirectory(progressFile);
            }
            string lastLine = ReadLastLine(Path.Combine(progressFile, "progress.txt"));
            int index = lastLine.IndexOf(',') + 1;
            int lastIndex = lastLine.LastIndexOf(",65536");           
            if (lastIndex > index && index > 0)
            {                
                int progress;
                if (Int32.TryParse(lastLine.Substring(index, lastIndex - index), out progress))
                {
                    _progressNum = (int)(((float)progress * 100.0) / (float)UInt16.MaxValue);
                }               
            }
            else
            {
                index = lastLine.IndexOf('%');
                if (index > 5)
                {
                    lastLine = lastLine.Substring(index - 7, 6);
                    index = lastLine.IndexOf(' ');
                    if (index >= 0)
                    {
                        float progress;
                        if (float.TryParse(lastLine.Substring(index + 1), out progress))
                        {
                            _progressNum = progress;
                        }
                    }
                }
            }
        }

        public string ReadLastLine(string filename)
        {
            using (var stream = File.Open(filename, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
            {
                long position = stream.Length;

                int bufferSize = 78;
                var encoding = new UTF8Encoding();
                // Allow up to two bytes for data from the start of the previous
                // read which didn't quite make it as full characters
                byte[] buffer = new byte[bufferSize + 2];
                char[] charBuffer = new char[encoding.GetMaxCharCount(buffer.Length)];
                int leftOverData = 0;
                String previousEnd = null;
                // TextReader doesn't return an empty string if there's line break at the end
                // of the data. Therefore we don't return an empty string if it's our *first*
                // return.
                bool firstYield = true;

                // A line-feed at the start of the previous buffer means we need to swallow
                // the carriage-return at the end of this buffer - hence this needs declaring
                // way up here!
                bool swallowCarriageReturn = false;

                while (position > 0)
                {
                    int bytesToRead = Math.Min(position > int.MaxValue ? bufferSize : (int)position, bufferSize);

                    position -= bytesToRead;
                    stream.Position = position;
                    ReadExactly(stream, buffer, bytesToRead);
                    // If we haven't read a full buffer, but we had bytes left
                    // over from before, copy them to the end of the buffer
                    if (leftOverData > 0 && bytesToRead != bufferSize)
                    {
                        // Buffer.BlockCopy doesn't document its behaviour with respect
                        // to overlapping data: we *might* just have read 7 bytes instead of
                        // 8, and have two bytes to copy...
                        Array.Copy(buffer, bufferSize, buffer, bytesToRead, leftOverData);
                    }
                    // We've now *effectively* read this much data.
                    bytesToRead += leftOverData;

                    int firstCharPosition = 0;
                    leftOverData = firstCharPosition;

                    int charsRead = encoding.GetChars(buffer, firstCharPosition, bytesToRead - firstCharPosition, charBuffer, 0);
                    int endExclusive = charsRead;

                    for (int i = charsRead - 1; i >= 0; i--)
                    {
                        char lookingAt = charBuffer[i];
                        if (swallowCarriageReturn)
                        {
                            swallowCarriageReturn = false;
                            if (lookingAt == '\r')
                            {
                                endExclusive--;
                                continue;
                            }
                        }
                        // Anything non-line-breaking, just keep looking backwards
                        if (lookingAt != '\n' && lookingAt != '\r')
                        {
                            continue;
                        }
                        // End of CRLF? Swallow the preceding CR
                        if (lookingAt == '\n')
                        {
                            swallowCarriageReturn = true;
                        }
                        int start = i + 1;
                        string bufferContents = new string(charBuffer, start, endExclusive - start);
                        endExclusive = i;
                        string stringToYield = previousEnd == null ? bufferContents : bufferContents + previousEnd;
                        if (!firstYield || stringToYield.Length != 0)
                        {
                            if (stringToYield[0] != '\n' && stringToYield[0] != '\r')
                            { return stringToYield; }
                        }
                        firstYield = false;
                        previousEnd = null;
                    }

                    previousEnd = endExclusive == 0 ? null : (new string(charBuffer, 0, endExclusive) + previousEnd);

                    // If we didn't decode the start of the array, put it at the end for next time
                    if (leftOverData != 0)
                    {
                        Buffer.BlockCopy(buffer, 0, buffer, bufferSize, leftOverData);
                    }
                }
                if (leftOverData != 0)
                {
                    // At the start of the final buffer, we had the end of another character.
                    throw new InvalidDataException("Invalid UTF-8 data at start of stream");
                }
                
                return previousEnd ?? "";
            }
        }

        public static void ReadExactly(Stream input, byte[] buffer, int bytesToRead)
        {
            int index = 0;
            while (index < bytesToRead)
            {
                int read = input.Read(buffer, index, bytesToRead - index);
                if (read == 0)
                {
                    throw new EndOfStreamException
                        (String.Format("End of stream reached with {0} byte{1} left to read.",
                                       bytesToRead - index,
                                       bytesToRead - index == 1 ? "s" : ""));
                }
                index += read;
            }
        }

        private void radioCartoon_CheckedChanged(object sender, EventArgs e)
        {
            try { 
                Model.EncodeSetting = "Cartoon";
            }
            catch { }
        }

        private void radioHdx_CheckedChanged(object sender, EventArgs e)
        {
            try { 
                Model.EncodeSetting = "BluRay1080";
            }
            catch { }
        }

        private void radioDefault_CheckedChanged(object sender, EventArgs e)
        {
            Model.EncodeSetting = String.Empty;
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            timerStatus.Stop();
            if (this.AutoValidate != AutoValidate.Disable)
            {
                this.AutoValidate = AutoValidate.Disable;
                Invoke(new Action(Close));
            }
            else
            {
                SaveSettings().Wait(4000);
            }
        }

        private void buttonReadTitle_Click(object sender, EventArgs e)
        {
            try { 
                Model.ReadTitle();
            }
            catch { }
        }

        private void buttonClean_Click(object sender, EventArgs e)
        {
            try { 
                Model.Clean();
            }
            catch { }
        }

        private void textTitle_TextChanged(object sender, EventArgs e)
        {
            try { 
                string title = (textTitle.Text == "Detect") ? String.Empty : textTitle.Text;
                Model.Title = title;
            }
            catch { }
        }

        private void textTitle_Validating(object sender, CancelEventArgs e)
        {
            if (!String.IsNullOrEmpty(Model.TitleError))
            {
                e.Cancel = true;
            }
            this.errorProvider1.SetError(textTitle, Model.TitleError);
        }

        private void Form1_Deactivate(object sender, EventArgs e)
        {
            try
            {
                            
            }
            catch { }
        }

        private void Form1_Activated(object sender, EventArgs e)
        {
            try
            {
               
            }
            catch(Exception ex)
            {
                textLog.Text += ex.Message;
            }
        }

        private void textLength_Validating(object sender, CancelEventArgs e)
        {
            if (!String.IsNullOrEmpty(Model.FilmLengthError))
            {
                e.Cancel = true;
            }
            this.errorProvider1.SetError(textLength, Model.FilmLengthError);
        }

        private void textLength_TextChanged(object sender, EventArgs e)
        {
            try
            {
                if (textLength.Text.Length == 0 ||
                    (textLength.Text.Length > 1 &&
                    textLength.Text.Length < 4))
                {
                    Model.FilmLength = textLength.Text;
                }
            
            }
            catch { }
        }

        private void buttonBrowseRip_Click(object sender, EventArgs e)
        {
            string location = ShowFolderBrowser("Temporary Ripping Location",
                textTempRipDir.Text, Path.GetTempPath());
            if(!String.IsNullOrWhiteSpace(location))
            {
                textTempRipDir.Text = location;
            }
        }

        private string ShowFolderBrowser(string description, string initialText, string initialDir = "")
        {
            FolderBrowserDialog folderBrowser = new FolderBrowserDialog();
            folderBrowser.Description = description;
            if(!String.IsNullOrWhiteSpace(initialDir) && Directory.Exists(initialDir))
                folderBrowser.SelectedPath = initialDir;
            else
                folderBrowser.SelectedPath = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
            if (!String.IsNullOrWhiteSpace(initialText) &&
                Directory.Exists(initialText))
            {
                folderBrowser.SelectedPath = initialText;
            }
            else
            {
                try
                {
                    string tempFolder = Environment.ExpandEnvironmentVariables("%TEMP%");
                    if (!String.IsNullOrWhiteSpace(tempFolder))
                    {
                        folderBrowser.SelectedPath = tempFolder;
                    }
                }
                catch { }
            }

            folderBrowser.ShowNewFolderButton = true;
            if (folderBrowser.ShowDialog() == DialogResult.OK)
            {
                return folderBrowser.SelectedPath;
            }
            return String.Empty;
        }

        private void buttonConvertDir_Click(object sender, EventArgs e)
        {
            string location = ShowFolderBrowser("Temporary Conversion Location",
                textTempConvertDir.Text, Path.GetTempPath());
            if (!String.IsNullOrWhiteSpace(location))
            {
                textTempConvertDir.Text = location;
            }
        }
        
        private void buttonValue1_Click(object sender, EventArgs e)
        {
            try { 
            string location = ShowFolderBrowser("Value 1",
                textTempConvertDir.Text);
            if (!String.IsNullOrWhiteSpace(location))
            {
                textValue1.Text = location;
            }
            }
            catch { }
        }

        private void buttonValue2_Click(object sender, EventArgs e)
        {
            try { 
            string location = ShowFolderBrowser("Value 2",
                textTempConvertDir.Text);
            if (!String.IsNullOrWhiteSpace(location))
            {
                textValue2.Text = location;
            }
            }
            catch { }
        }

        private void buttonValue3_Click(object sender, EventArgs e)
        {
            try { 
            string location = ShowFolderBrowser("Value 3",
                textTempConvertDir.Text);
            if (!String.IsNullOrWhiteSpace(location))
            {
                textValue3.Text = location;
            }
            }
            catch { }
        }

        private void buttonOutputLocation_Click(object sender, EventArgs e)
        {
            string location = ShowFolderBrowser("Video Output Folder",
                textTempConvertDir.Text, Environment.GetFolderPath(Environment.SpecialFolder.CommonVideos));
            if (!String.IsNullOrWhiteSpace(location))
            {
                textOutputLocation.Text = location;
            }
        }

        private void textTempRipDir_TextChanged(object sender, EventArgs e)
        {
            _vm.TempRipDirectory = textTempRipDir.Text;
        }

        private void textTempConvertDir_TextChanged(object sender, EventArgs e)
        {
            _vm.TempConvertDirectory = textTempConvertDir.Text;
        }

        private void SetValue(string name, string value)
        {
            if (!String.IsNullOrWhiteSpace(name))
            {
                _vm.AddParameter(name, value);
            }
        }

        private void textValue1_TextChanged(object sender, EventArgs e)
        {
            SetValue(textName1.Text, textValue1.Text);
        }

        private void textName1_TextChanged(object sender, EventArgs e)
        {
            SetValue(textName1.Text, textValue1.Text);
        }

        private void textValue2_TextChanged(object sender, EventArgs e)
        {
            SetValue(textName2.Text, textValue2.Text);
        }

        private void textName2_TextChanged(object sender, EventArgs e)
        {
            SetValue(textName2.Text, textValue2.Text);
        }

        private void textValue3_TextChanged(object sender, EventArgs e)
        {
            SetValue(textName3.Text, textValue3.Text);
        }

        private void textName3_TextChanged(object sender, EventArgs e)
        {
            SetValue(textName3.Text, textValue3.Text);
        }

        private void textOutputLocation_TextChanged(object sender, EventArgs e)
        {
            Model.VideoOutputLocation = textOutputLocation.Text;
        }

        private void textOutputLocation_Validating(object sender, CancelEventArgs e)
        {
            if(!String.IsNullOrEmpty(Model.VideoOutputLocationError))
            {
                e.Cancel = true;
            }
            this.errorProvider1.SetError(textOutputLocation, Model.VideoOutputLocationError);
        }

        private void textSeasonNumber_TextChanged(object sender, EventArgs e)
        {
            string season = (textSeasonNumber.Text == "Detect") ? String.Empty : textSeasonNumber.Text;
            Model.Season = season;
        }

        private void textSeasonNumber_Validating(object sender, CancelEventArgs e)
        {
            if (!String.IsNullOrEmpty(Model.SeasonError))
            {
                e.Cancel = true;
            }
            this.errorProvider1.SetError(textSeasonNumber, Model.SeasonError);
        }

        private void checkSeason_CheckedChanged(object sender, EventArgs e)
        {
            if( checkSeason.Checked )
            {
                textSeasonNumber.ReadOnly = false;
                textSeasonNumber.Text = String.Empty;
                textSeasonNumber.ForeColor = Form1.DefaultForeColor;
            }
            else
            {
                textSeasonNumber.Text = "Detect";
                textSeasonNumber.ReadOnly = true;
                textSeasonNumber.ForeColor = SystemColors.GrayText;
            }
        }

        private void checkTitle_CheckedChanged(object sender, EventArgs e)
        {
            if (checkTitle.Checked)
            {
                textTitle.ReadOnly = false;
                textTitle.Text = String.Empty;
                textTitle.ForeColor = Form1.DefaultForeColor;
            }
            else
            {
                textTitle.ReadOnly = false;
                textTitle.Text = "Detect";
                textTitle.ReadOnly = true;
                textTitle.ForeColor = SystemColors.GrayText;
            }
        }
        
        private void buttonIsoLang_Click(object sender, EventArgs e)
        {
            try
            {
                Process.Start("https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes");
            }
            catch { }
        }


        private void textBoxLanguage_TextChanged(object sender, EventArgs e)
        {
            string text = textBoxLanguage.Text;
            if (text.Length == 0 || text.Length >= 3)
            {
                Model.LangCode = textBoxLanguage.Text;
            }
        }

        private void textBoxLanguage_Validating(object sender, CancelEventArgs e)
        {
            if (!String.IsNullOrEmpty(Model.LangCodeError))
            {
                e.Cancel = true;
            }
            this.errorProvider1.SetError(textBoxLanguage, Model.LangCodeError);
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetEncodeSeting();
        }

        private void SetEncodeSeting()
        {
            string selection = comboBox1.SelectedItem?.ToString();
            if (selection != null)
            {
                switch (selection)
                {
                    case "Cartoon":
                        Model.EncodeSetting = "Cartoon";
                        break;
                    case "SD":
                        if (comboRepair.SelectedIndex == 1)
                            Model.EncodeSetting = "Repair";
                        else if (comboRepair.SelectedIndex == 2)
                            Model.EncodeSetting = "Restore";
                        else
                            Model.EncodeSetting = "DVD";
                        break;
                    case "HD":
                        if (comboRepair.SelectedIndex > 0)
                            Model.EncodeSetting = "Repair720";
                        else
                            Model.EncodeSetting = "BluRay720";
                        break;
                    case "HDX":
                        Model.EncodeSetting = "BluRay1080";
                        break;
                    case "UHD":
                        Model.EncodeSetting = "BluRay4K";
                        break;
                    default:
                        if (comboRepair.SelectedIndex == 1)
                            Model.EncodeSetting = "Repair";
                        else if (comboRepair.SelectedIndex == 2)
                            Model.EncodeSetting = "Restore";
                        else
                            Model.EncodeSetting = string.Empty;
                        break;
                }
            }
        }

        private void chkRepair_CheckedChanged(object sender, EventArgs e)
        {
            SetEncodeSeting();
        }

        private void Form1_Resize(object sender, EventArgs e)
        {
            if (WindowState == FormWindowState.Minimized)
            {
                _convertPriority = ProcessPriorityClass.BelowNormal;
            }
            else
            {
                _convertPriority = ProcessPriorityClass.Normal;
            }
        }
    }
}
