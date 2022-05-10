
namespace VideoRip
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.btnStart = new System.Windows.Forms.Button();
            this.labelYear = new System.Windows.Forms.Label();
            this.textYear = new System.Windows.Forms.TextBox();
            this.errorProvider1 = new System.Windows.Forms.ErrorProvider(this.components);
            this.labelEpisode = new System.Windows.Forms.Label();
            this.groupMediaType = new System.Windows.Forms.GroupBox();
            this.radioMultiFilm = new System.Windows.Forms.RadioButton();
            this.radioDetect = new System.Windows.Forms.RadioButton();
            this.radioTv = new System.Windows.Forms.RadioButton();
            this.radioFilm = new System.Windows.Forms.RadioButton();
            this.comboEpisode = new System.Windows.Forms.ComboBox();
            this.labelMinutes = new System.Windows.Forms.Label();
            this.labelSpecial = new System.Windows.Forms.Label();
            this.textSpecialInfo = new System.Windows.Forms.TextBox();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.textStatus = new System.Windows.Forms.TextBox();
            this.tabPage2 = new System.Windows.Forms.TabPage();
            this.textLog = new System.Windows.Forms.TextBox();
            this.tabSettings = new System.Windows.Forms.TabPage();
            this.buttonIsoLang = new System.Windows.Forms.Button();
            this.textBoxLanguage = new System.Windows.Forms.TextBox();
            this.labelLanguage = new System.Windows.Forms.Label();
            this.labelValues = new System.Windows.Forms.Label();
            this.labelNames = new System.Windows.Forms.Label();
            this.buttonValue3 = new System.Windows.Forms.Button();
            this.buttonValue2 = new System.Windows.Forms.Button();
            this.buttonValue1 = new System.Windows.Forms.Button();
            this.textValue3 = new System.Windows.Forms.TextBox();
            this.textValue2 = new System.Windows.Forms.TextBox();
            this.textName3 = new System.Windows.Forms.TextBox();
            this.textName2 = new System.Windows.Forms.TextBox();
            this.textValue1 = new System.Windows.Forms.TextBox();
            this.textName1 = new System.Windows.Forms.TextBox();
            this.labelOtherParam = new System.Windows.Forms.Label();
            this.buttonOutputLocation = new System.Windows.Forms.Button();
            this.textOutputLocation = new System.Windows.Forms.TextBox();
            this.labelOutputLocation = new System.Windows.Forms.Label();
            this.buttonConvertDir = new System.Windows.Forms.Button();
            this.buttonBrowseRip = new System.Windows.Forms.Button();
            this.textTempConvertDir = new System.Windows.Forms.TextBox();
            this.textTempRipDir = new System.Windows.Forms.TextBox();
            this.labelTempConvertDir = new System.Windows.Forms.Label();
            this.labelTempRipping = new System.Windows.Forms.Label();
            this.tabAbout = new System.Windows.Forms.TabPage();
            this.labelCopyright = new System.Windows.Forms.Label();
            this.labelVersion = new System.Windows.Forms.Label();
            this.labelVideoRip = new System.Windows.Forms.Label();
            this.linkLabel1 = new System.Windows.Forms.LinkLabel();
            this.progressAction = new System.Windows.Forms.ProgressBar();
            this.progressTotal = new System.Windows.Forms.ProgressBar();
            this.timerStatus = new System.Windows.Forms.Timer(this.components);
            this.labelTitle = new System.Windows.Forms.Label();
            this.textTitle = new System.Windows.Forms.TextBox();
            this.buttonClean = new System.Windows.Forms.Button();
            this.buttonReadTitle = new System.Windows.Forms.Button();
            this.progressReadTitle = new System.Windows.Forms.ProgressBar();
            this.toolTip1 = new System.Windows.Forms.ToolTip(this.components);
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.chkBonus = new System.Windows.Forms.CheckBox();
            this.textLength = new System.Windows.Forms.TextBox();
            this.labelSeasonNumber = new System.Windows.Forms.Label();
            this.textSeasonNumber = new System.Windows.Forms.TextBox();
            this.checkSeason = new System.Windows.Forms.CheckBox();
            this.checkTitle = new System.Windows.Forms.CheckBox();
            this.comboBox1 = new System.Windows.Forms.ComboBox();
            this.labelEncoding = new System.Windows.Forms.Label();
            this.comboRepair = new System.Windows.Forms.ComboBox();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider1)).BeginInit();
            this.groupMediaType.SuspendLayout();
            this.tabControl1.SuspendLayout();
            this.tabPage1.SuspendLayout();
            this.tabPage2.SuspendLayout();
            this.tabSettings.SuspendLayout();
            this.tabAbout.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.SuspendLayout();
            // 
            // btnStart
            // 
            this.btnStart.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.btnStart.Location = new System.Drawing.Point(16, 323);
            this.btnStart.Name = "btnStart";
            this.btnStart.Size = new System.Drawing.Size(75, 23);
            this.btnStart.TabIndex = 16;
            this.btnStart.Text = "Start";
            this.toolTip1.SetToolTip(this.btnStart, "Begin ripping and encoding");
            this.btnStart.UseVisualStyleBackColor = true;
            this.btnStart.Click += new System.EventHandler(this.btnStart_Click);
            // 
            // labelYear
            // 
            this.labelYear.AutoSize = true;
            this.labelYear.Location = new System.Drawing.Point(13, 249);
            this.labelYear.Name = "labelYear";
            this.labelYear.Size = new System.Drawing.Size(71, 13);
            this.labelYear.TabIndex = 1;
            this.labelYear.Text = "Release Year";
            this.toolTip1.SetToolTip(this.labelYear, "Year the show was released. For TV shows, the year of the first season");
            // 
            // textYear
            // 
            this.textYear.Location = new System.Drawing.Point(141, 249);
            this.textYear.Name = "textYear";
            this.textYear.Size = new System.Drawing.Size(70, 20);
            this.textYear.TabIndex = 11;
            this.textYear.TextChanged += new System.EventHandler(this.textYear_TextChanged);
            this.textYear.Validating += new System.ComponentModel.CancelEventHandler(this.textYear_Validating);
            // 
            // errorProvider1
            // 
            this.errorProvider1.ContainerControl = this;
            // 
            // labelEpisode
            // 
            this.labelEpisode.AutoSize = true;
            this.labelEpisode.Location = new System.Drawing.Point(13, 147);
            this.labelEpisode.Name = "labelEpisode";
            this.labelEpisode.Size = new System.Drawing.Size(81, 13);
            this.labelEpisode.TabIndex = 3;
            this.labelEpisode.Text = "Episode Length";
            this.toolTip1.SetToolTip(this.labelEpisode, "Approximate TV show episode length\r\nFilm length (only needed for Lions Gate)");
            // 
            // groupMediaType
            // 
            this.groupMediaType.Controls.Add(this.radioMultiFilm);
            this.groupMediaType.Controls.Add(this.radioDetect);
            this.groupMediaType.Controls.Add(this.radioTv);
            this.groupMediaType.Controls.Add(this.radioFilm);
            this.groupMediaType.Location = new System.Drawing.Point(12, 44);
            this.groupMediaType.Name = "groupMediaType";
            this.groupMediaType.Size = new System.Drawing.Size(199, 68);
            this.groupMediaType.TabIndex = 4;
            this.groupMediaType.TabStop = false;
            this.groupMediaType.Text = "Media Type";
            this.toolTip1.SetToolTip(this.groupMediaType, "The type of show being ripped");
            // 
            // radioMultiFilm
            // 
            this.radioMultiFilm.AutoSize = true;
            this.radioMultiFilm.Location = new System.Drawing.Point(69, 22);
            this.radioMultiFilm.Name = "radioMultiFilm";
            this.radioMultiFilm.Size = new System.Drawing.Size(92, 17);
            this.radioMultiFilm.TabIndex = 2;
            this.radioMultiFilm.TabStop = true;
            this.radioMultiFilm.Text = "Film Collection";
            this.toolTip1.SetToolTip(this.radioMultiFilm, "Multiple movies on a single disc. This includes director\'s cut");
            this.radioMultiFilm.UseVisualStyleBackColor = true;
            this.radioMultiFilm.CheckedChanged += new System.EventHandler(this.radioMultiFilm_CheckedChanged);
            // 
            // radioDetect
            // 
            this.radioDetect.AutoSize = true;
            this.radioDetect.Checked = true;
            this.radioDetect.Location = new System.Drawing.Point(6, 19);
            this.radioDetect.Name = "radioDetect";
            this.radioDetect.Size = new System.Drawing.Size(57, 17);
            this.radioDetect.TabIndex = 1;
            this.radioDetect.TabStop = true;
            this.radioDetect.Text = "Detect";
            this.toolTip1.SetToolTip(this.radioDetect, "Tries to determine the type of show automatically");
            this.radioDetect.UseVisualStyleBackColor = true;
            this.radioDetect.CheckedChanged += new System.EventHandler(this.radioDetect_CheckedChanged);
            // 
            // radioTv
            // 
            this.radioTv.AutoSize = true;
            this.radioTv.Location = new System.Drawing.Point(6, 42);
            this.radioTv.Name = "radioTv";
            this.radioTv.Size = new System.Drawing.Size(39, 17);
            this.radioTv.TabIndex = 3;
            this.radioTv.TabStop = true;
            this.radioTv.Text = "TV";
            this.toolTip1.SetToolTip(this.radioTv, "Television Show");
            this.radioTv.UseVisualStyleBackColor = true;
            this.radioTv.CheckedChanged += new System.EventHandler(this.radioTv_CheckedChanged);
            // 
            // radioFilm
            // 
            this.radioFilm.AutoSize = true;
            this.radioFilm.Location = new System.Drawing.Point(69, 42);
            this.radioFilm.Name = "radioFilm";
            this.radioFilm.Size = new System.Drawing.Size(43, 17);
            this.radioFilm.TabIndex = 4;
            this.radioFilm.TabStop = true;
            this.radioFilm.Text = "Film";
            this.toolTip1.SetToolTip(this.radioFilm, "Movie");
            this.radioFilm.UseVisualStyleBackColor = true;
            this.radioFilm.CheckedChanged += new System.EventHandler(this.radioFilm_CheckedChanged);
            // 
            // comboEpisode
            // 
            this.comboEpisode.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboEpisode.FormattingEnabled = true;
            this.comboEpisode.Items.AddRange(new object[] {
            "Detect",
            "5",
            "15",
            "30",
            "60"});
            this.comboEpisode.Location = new System.Drawing.Point(100, 143);
            this.comboEpisode.MaxDropDownItems = 2;
            this.comboEpisode.Name = "comboEpisode";
            this.comboEpisode.Size = new System.Drawing.Size(63, 21);
            this.comboEpisode.TabIndex = 5;
            this.comboEpisode.SelectedIndexChanged += new System.EventHandler(this.comboEpisode_SelectedIndexChanged);
            this.comboEpisode.Validating += new System.ComponentModel.CancelEventHandler(this.comboEpisode_Validating);
            // 
            // labelMinutes
            // 
            this.labelMinutes.AutoSize = true;
            this.labelMinutes.Location = new System.Drawing.Point(169, 147);
            this.labelMinutes.Name = "labelMinutes";
            this.labelMinutes.Size = new System.Drawing.Size(43, 13);
            this.labelMinutes.TabIndex = 6;
            this.labelMinutes.Text = "minutes";
            // 
            // labelSpecial
            // 
            this.labelSpecial.AutoSize = true;
            this.labelSpecial.Location = new System.Drawing.Point(13, 272);
            this.labelSpecial.Name = "labelSpecial";
            this.labelSpecial.Size = new System.Drawing.Size(66, 13);
            this.labelSpecial.TabIndex = 9;
            this.labelSpecial.Text = "Special Info:";
            this.toolTip1.SetToolTip(this.labelSpecial, "Extra information to add to the title (e.g. Extended Edition)");
            // 
            // textSpecialInfo
            // 
            this.textSpecialInfo.Location = new System.Drawing.Point(16, 288);
            this.textSpecialInfo.MaxLength = 64;
            this.textSpecialInfo.Name = "textSpecialInfo";
            this.textSpecialInfo.Size = new System.Drawing.Size(195, 20);
            this.textSpecialInfo.TabIndex = 12;
            this.toolTip1.SetToolTip(this.textSpecialInfo, "Added to filename\r\n(Special Edition, Director\'s cut, etc.)");
            this.textSpecialInfo.TextChanged += new System.EventHandler(this.textSpecialInfo_TextChanged);
            this.textSpecialInfo.Validating += new System.ComponentModel.CancelEventHandler(this.textSpecialInfo_Validating);
            // 
            // tabControl1
            // 
            this.tabControl1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.tabControl1.Controls.Add(this.tabPage1);
            this.tabControl1.Controls.Add(this.tabPage2);
            this.tabControl1.Controls.Add(this.tabSettings);
            this.tabControl1.Controls.Add(this.tabAbout);
            this.tabControl1.Location = new System.Drawing.Point(217, 12);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(375, 303);
            this.tabControl1.TabIndex = 18;
            // 
            // tabPage1
            // 
            this.tabPage1.Controls.Add(this.textStatus);
            this.tabPage1.Location = new System.Drawing.Point(4, 22);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage1.Size = new System.Drawing.Size(367, 277);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "Status";
            this.tabPage1.UseVisualStyleBackColor = true;
            // 
            // textStatus
            // 
            this.textStatus.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.textStatus.Location = new System.Drawing.Point(6, 4);
            this.textStatus.Multiline = true;
            this.textStatus.Name = "textStatus";
            this.textStatus.ReadOnly = true;
            this.textStatus.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textStatus.Size = new System.Drawing.Size(354, 270);
            this.textStatus.TabIndex = 0;
            // 
            // tabPage2
            // 
            this.tabPage2.Controls.Add(this.textLog);
            this.tabPage2.Location = new System.Drawing.Point(4, 22);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage2.Size = new System.Drawing.Size(367, 277);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "Log";
            this.tabPage2.UseVisualStyleBackColor = true;
            // 
            // textLog
            // 
            this.textLog.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.textLog.Location = new System.Drawing.Point(7, 7);
            this.textLog.Multiline = true;
            this.textLog.Name = "textLog";
            this.textLog.ReadOnly = true;
            this.textLog.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textLog.Size = new System.Drawing.Size(354, 264);
            this.textLog.TabIndex = 0;
            // 
            // tabSettings
            // 
            this.tabSettings.BackColor = System.Drawing.SystemColors.Control;
            this.tabSettings.Controls.Add(this.buttonIsoLang);
            this.tabSettings.Controls.Add(this.textBoxLanguage);
            this.tabSettings.Controls.Add(this.labelLanguage);
            this.tabSettings.Controls.Add(this.labelValues);
            this.tabSettings.Controls.Add(this.labelNames);
            this.tabSettings.Controls.Add(this.buttonValue3);
            this.tabSettings.Controls.Add(this.buttonValue2);
            this.tabSettings.Controls.Add(this.buttonValue1);
            this.tabSettings.Controls.Add(this.textValue3);
            this.tabSettings.Controls.Add(this.textValue2);
            this.tabSettings.Controls.Add(this.textName3);
            this.tabSettings.Controls.Add(this.textName2);
            this.tabSettings.Controls.Add(this.textValue1);
            this.tabSettings.Controls.Add(this.textName1);
            this.tabSettings.Controls.Add(this.labelOtherParam);
            this.tabSettings.Controls.Add(this.buttonOutputLocation);
            this.tabSettings.Controls.Add(this.textOutputLocation);
            this.tabSettings.Controls.Add(this.labelOutputLocation);
            this.tabSettings.Controls.Add(this.buttonConvertDir);
            this.tabSettings.Controls.Add(this.buttonBrowseRip);
            this.tabSettings.Controls.Add(this.textTempConvertDir);
            this.tabSettings.Controls.Add(this.textTempRipDir);
            this.tabSettings.Controls.Add(this.labelTempConvertDir);
            this.tabSettings.Controls.Add(this.labelTempRipping);
            this.tabSettings.Location = new System.Drawing.Point(4, 22);
            this.tabSettings.Name = "tabSettings";
            this.tabSettings.Size = new System.Drawing.Size(367, 277);
            this.tabSettings.TabIndex = 2;
            this.tabSettings.Text = "Settings";
            // 
            // buttonIsoLang
            // 
            this.buttonIsoLang.Location = new System.Drawing.Point(330, 113);
            this.buttonIsoLang.Name = "buttonIsoLang";
            this.buttonIsoLang.Size = new System.Drawing.Size(25, 23);
            this.buttonIsoLang.TabIndex = 23;
            this.buttonIsoLang.Text = "🔗";
            this.buttonIsoLang.UseVisualStyleBackColor = true;
            this.buttonIsoLang.Click += new System.EventHandler(this.buttonIsoLang_Click);
            // 
            // textBoxLanguage
            // 
            this.textBoxLanguage.Location = new System.Drawing.Point(257, 115);
            this.textBoxLanguage.Name = "textBoxLanguage";
            this.textBoxLanguage.Size = new System.Drawing.Size(67, 20);
            this.textBoxLanguage.TabIndex = 22;
            this.textBoxLanguage.TextChanged += new System.EventHandler(this.textBoxLanguage_TextChanged);
            this.textBoxLanguage.Validating += new System.ComponentModel.CancelEventHandler(this.textBoxLanguage_Validating);
            // 
            // labelLanguage
            // 
            this.labelLanguage.AutoSize = true;
            this.labelLanguage.Location = new System.Drawing.Point(19, 115);
            this.labelLanguage.Name = "labelLanguage";
            this.labelLanguage.Size = new System.Drawing.Size(55, 13);
            this.labelLanguage.TabIndex = 21;
            this.labelLanguage.Text = "Language";
            // 
            // labelValues
            // 
            this.labelValues.AutoSize = true;
            this.labelValues.Location = new System.Drawing.Point(149, 173);
            this.labelValues.Name = "labelValues";
            this.labelValues.Size = new System.Drawing.Size(39, 13);
            this.labelValues.TabIndex = 20;
            this.labelValues.Text = "Values";
            // 
            // labelNames
            // 
            this.labelNames.AutoSize = true;
            this.labelNames.Location = new System.Drawing.Point(19, 173);
            this.labelNames.Name = "labelNames";
            this.labelNames.Size = new System.Drawing.Size(40, 13);
            this.labelNames.TabIndex = 19;
            this.labelNames.Text = "Names";
            // 
            // buttonValue3
            // 
            this.buttonValue3.Location = new System.Drawing.Point(330, 244);
            this.buttonValue3.Name = "buttonValue3";
            this.buttonValue3.Size = new System.Drawing.Size(25, 23);
            this.buttonValue3.TabIndex = 18;
            this.buttonValue3.Text = "...";
            this.buttonValue3.UseVisualStyleBackColor = true;
            this.buttonValue3.Click += new System.EventHandler(this.buttonValue3_Click);
            // 
            // buttonValue2
            // 
            this.buttonValue2.Location = new System.Drawing.Point(330, 215);
            this.buttonValue2.Name = "buttonValue2";
            this.buttonValue2.Size = new System.Drawing.Size(25, 23);
            this.buttonValue2.TabIndex = 17;
            this.buttonValue2.Text = "...";
            this.buttonValue2.UseVisualStyleBackColor = true;
            this.buttonValue2.Click += new System.EventHandler(this.buttonValue2_Click);
            // 
            // buttonValue1
            // 
            this.buttonValue1.Location = new System.Drawing.Point(330, 186);
            this.buttonValue1.Name = "buttonValue1";
            this.buttonValue1.Size = new System.Drawing.Size(25, 23);
            this.buttonValue1.TabIndex = 16;
            this.buttonValue1.Text = "...";
            this.buttonValue1.UseVisualStyleBackColor = true;
            this.buttonValue1.Click += new System.EventHandler(this.buttonValue1_Click);
            // 
            // textValue3
            // 
            this.textValue3.Location = new System.Drawing.Point(152, 247);
            this.textValue3.Name = "textValue3";
            this.textValue3.Size = new System.Drawing.Size(172, 20);
            this.textValue3.TabIndex = 15;
            this.textValue3.TextChanged += new System.EventHandler(this.textValue3_TextChanged);
            // 
            // textValue2
            // 
            this.textValue2.Location = new System.Drawing.Point(152, 218);
            this.textValue2.Name = "textValue2";
            this.textValue2.Size = new System.Drawing.Size(172, 20);
            this.textValue2.TabIndex = 14;
            this.textValue2.TextChanged += new System.EventHandler(this.textValue2_TextChanged);
            // 
            // textName3
            // 
            this.textName3.Location = new System.Drawing.Point(22, 247);
            this.textName3.Name = "textName3";
            this.textName3.Size = new System.Drawing.Size(100, 20);
            this.textName3.TabIndex = 13;
            this.textName3.TextChanged += new System.EventHandler(this.textName3_TextChanged);
            // 
            // textName2
            // 
            this.textName2.Location = new System.Drawing.Point(22, 218);
            this.textName2.Name = "textName2";
            this.textName2.Size = new System.Drawing.Size(100, 20);
            this.textName2.TabIndex = 12;
            this.textName2.TextChanged += new System.EventHandler(this.textName2_TextChanged);
            // 
            // textValue1
            // 
            this.textValue1.Location = new System.Drawing.Point(152, 189);
            this.textValue1.Name = "textValue1";
            this.textValue1.Size = new System.Drawing.Size(172, 20);
            this.textValue1.TabIndex = 11;
            this.textValue1.TextChanged += new System.EventHandler(this.textValue1_TextChanged);
            // 
            // textName1
            // 
            this.textName1.Location = new System.Drawing.Point(22, 189);
            this.textName1.Name = "textName1";
            this.textName1.Size = new System.Drawing.Size(100, 20);
            this.textName1.TabIndex = 10;
            this.textName1.TextChanged += new System.EventHandler(this.textName1_TextChanged);
            // 
            // labelOtherParam
            // 
            this.labelOtherParam.AutoSize = true;
            this.labelOtherParam.Location = new System.Drawing.Point(19, 150);
            this.labelOtherParam.Name = "labelOtherParam";
            this.labelOtherParam.Size = new System.Drawing.Size(74, 13);
            this.labelOtherParam.TabIndex = 9;
            this.labelOtherParam.Text = "Other Settings";
            this.toolTip1.SetToolTip(this.labelOtherParam, "Allows other settings to be specified by name");
            // 
            // buttonOutputLocation
            // 
            this.buttonOutputLocation.Location = new System.Drawing.Point(330, 81);
            this.buttonOutputLocation.Name = "buttonOutputLocation";
            this.buttonOutputLocation.Size = new System.Drawing.Size(25, 23);
            this.buttonOutputLocation.TabIndex = 8;
            this.buttonOutputLocation.Text = "...";
            this.buttonOutputLocation.UseVisualStyleBackColor = true;
            this.buttonOutputLocation.Click += new System.EventHandler(this.buttonOutputLocation_Click);
            // 
            // textOutputLocation
            // 
            this.textOutputLocation.Location = new System.Drawing.Point(200, 83);
            this.textOutputLocation.Name = "textOutputLocation";
            this.textOutputLocation.Size = new System.Drawing.Size(124, 20);
            this.textOutputLocation.TabIndex = 7;
            this.textOutputLocation.TextChanged += new System.EventHandler(this.textOutputLocation_TextChanged);
            this.textOutputLocation.Validating += new System.ComponentModel.CancelEventHandler(this.textOutputLocation_Validating);
            // 
            // labelOutputLocation
            // 
            this.labelOutputLocation.AutoSize = true;
            this.labelOutputLocation.Location = new System.Drawing.Point(19, 86);
            this.labelOutputLocation.Name = "labelOutputLocation";
            this.labelOutputLocation.Size = new System.Drawing.Size(101, 13);
            this.labelOutputLocation.TabIndex = 6;
            this.labelOutputLocation.Text = "Video Output Folder";
            this.toolTip1.SetToolTip(this.labelOutputLocation, "Folder completed videos are saved to");
            // 
            // buttonConvertDir
            // 
            this.buttonConvertDir.Location = new System.Drawing.Point(330, 50);
            this.buttonConvertDir.Name = "buttonConvertDir";
            this.buttonConvertDir.Size = new System.Drawing.Size(25, 23);
            this.buttonConvertDir.TabIndex = 5;
            this.buttonConvertDir.Text = "...";
            this.buttonConvertDir.UseVisualStyleBackColor = true;
            this.buttonConvertDir.Click += new System.EventHandler(this.buttonConvertDir_Click);
            // 
            // buttonBrowseRip
            // 
            this.buttonBrowseRip.Location = new System.Drawing.Point(330, 20);
            this.buttonBrowseRip.Name = "buttonBrowseRip";
            this.buttonBrowseRip.Size = new System.Drawing.Size(25, 23);
            this.buttonBrowseRip.TabIndex = 4;
            this.buttonBrowseRip.Text = "...";
            this.buttonBrowseRip.UseVisualStyleBackColor = true;
            this.buttonBrowseRip.Click += new System.EventHandler(this.buttonBrowseRip_Click);
            // 
            // textTempConvertDir
            // 
            this.textTempConvertDir.Location = new System.Drawing.Point(200, 52);
            this.textTempConvertDir.Name = "textTempConvertDir";
            this.textTempConvertDir.Size = new System.Drawing.Size(124, 20);
            this.textTempConvertDir.TabIndex = 3;
            this.textTempConvertDir.TextChanged += new System.EventHandler(this.textTempConvertDir_TextChanged);
            // 
            // textTempRipDir
            // 
            this.textTempRipDir.Location = new System.Drawing.Point(200, 20);
            this.textTempRipDir.Name = "textTempRipDir";
            this.textTempRipDir.Size = new System.Drawing.Size(124, 20);
            this.textTempRipDir.TabIndex = 2;
            this.textTempRipDir.TextChanged += new System.EventHandler(this.textTempRipDir_TextChanged);
            // 
            // labelTempConvertDir
            // 
            this.labelTempConvertDir.AutoSize = true;
            this.labelTempConvertDir.Location = new System.Drawing.Point(19, 55);
            this.labelTempConvertDir.Name = "labelTempConvertDir";
            this.labelTempConvertDir.Size = new System.Drawing.Size(158, 13);
            this.labelTempConvertDir.TabIndex = 1;
            this.labelTempConvertDir.Text = "Temporary Conversion Directory";
            this.toolTip1.SetToolTip(this.labelTempConvertDir, "Folder videos convert to. No other programs should use this folder.");
            // 
            // labelTempRipping
            // 
            this.labelTempRipping.AutoSize = true;
            this.labelTempRipping.Location = new System.Drawing.Point(19, 25);
            this.labelTempRipping.Name = "labelTempRipping";
            this.labelTempRipping.Size = new System.Drawing.Size(121, 13);
            this.labelTempRipping.TabIndex = 0;
            this.labelTempRipping.Text = "Temporary Rip Directory";
            this.toolTip1.SetToolTip(this.labelTempRipping, "Folder videos rip to. No other programs should use this folder.");
            // 
            // tabAbout
            // 
            this.tabAbout.BackColor = System.Drawing.SystemColors.Control;
            this.tabAbout.Controls.Add(this.labelCopyright);
            this.tabAbout.Controls.Add(this.labelVersion);
            this.tabAbout.Controls.Add(this.labelVideoRip);
            this.tabAbout.Controls.Add(this.linkLabel1);
            this.tabAbout.Location = new System.Drawing.Point(4, 22);
            this.tabAbout.Name = "tabAbout";
            this.tabAbout.Size = new System.Drawing.Size(367, 277);
            this.tabAbout.TabIndex = 3;
            this.tabAbout.Text = "About";
            // 
            // labelCopyright
            // 
            this.labelCopyright.AutoSize = true;
            this.labelCopyright.Font = new System.Drawing.Font("Calibri", 11F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelCopyright.Location = new System.Drawing.Point(18, 67);
            this.labelCopyright.Name = "labelCopyright";
            this.labelCopyright.Size = new System.Drawing.Size(115, 18);
            this.labelCopyright.TabIndex = 4;
            this.labelCopyright.Text = "Copyright © 2020";
            // 
            // labelVersion
            // 
            this.labelVersion.AutoSize = true;
            this.labelVersion.Font = new System.Drawing.Font("Calibri", 11F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelVersion.Location = new System.Drawing.Point(18, 49);
            this.labelVersion.Name = "labelVersion";
            this.labelVersion.Size = new System.Drawing.Size(76, 18);
            this.labelVersion.TabIndex = 3;
            this.labelVersion.Text = "Version 1.0";
            // 
            // labelVideoRip
            // 
            this.labelVideoRip.AutoSize = true;
            this.labelVideoRip.Font = new System.Drawing.Font("Calibri", 16F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelVideoRip.Location = new System.Drawing.Point(18, 20);
            this.labelVideoRip.Name = "labelVideoRip";
            this.labelVideoRip.Size = new System.Drawing.Size(98, 27);
            this.labelVideoRip.TabIndex = 2;
            this.labelVideoRip.Text = "Video Rip";
            // 
            // linkLabel1
            // 
            this.linkLabel1.AutoSize = true;
            this.linkLabel1.LinkArea = new System.Windows.Forms.LinkArea(14, 54);
            this.linkLabel1.Location = new System.Drawing.Point(21, 204);
            this.linkLabel1.Name = "linkLabel1";
            this.linkLabel1.Size = new System.Drawing.Size(286, 17);
            this.linkLabel1.TabIndex = 1;
            this.linkLabel1.TabStop = true;
            this.linkLabel1.Text = "Icons made by https://www.flaticon.com/authors/eucalyp";
            this.linkLabel1.UseCompatibleTextRendering = true;
            // 
            // progressAction
            // 
            this.progressAction.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.progressAction.ForeColor = System.Drawing.Color.Gold;
            this.progressAction.Location = new System.Drawing.Point(221, 323);
            this.progressAction.Name = "progressAction";
            this.progressAction.Size = new System.Drawing.Size(157, 23);
            this.progressAction.Style = System.Windows.Forms.ProgressBarStyle.Continuous;
            this.progressAction.TabIndex = 13;
            // 
            // progressTotal
            // 
            this.progressTotal.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.progressTotal.Location = new System.Drawing.Point(421, 323);
            this.progressTotal.Name = "progressTotal";
            this.progressTotal.Size = new System.Drawing.Size(167, 23);
            this.progressTotal.Style = System.Windows.Forms.ProgressBarStyle.Continuous;
            this.progressTotal.TabIndex = 14;
            // 
            // labelTitle
            // 
            this.labelTitle.AutoSize = true;
            this.labelTitle.Location = new System.Drawing.Point(15, 204);
            this.labelTitle.Name = "labelTitle";
            this.labelTitle.Size = new System.Drawing.Size(27, 13);
            this.labelTitle.TabIndex = 15;
            this.labelTitle.Text = "Title";
            this.toolTip1.SetToolTip(this.labelTitle, "Title of the movie. Must be a valid filename");
            // 
            // textTitle
            // 
            this.textTitle.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textTitle.ForeColor = System.Drawing.SystemColors.GrayText;
            this.textTitle.Location = new System.Drawing.Point(39, 223);
            this.textTitle.Name = "textTitle";
            this.textTitle.ReadOnly = true;
            this.textTitle.Size = new System.Drawing.Size(172, 20);
            this.textTitle.TabIndex = 10;
            this.textTitle.Text = "Detect";
            this.textTitle.TextChanged += new System.EventHandler(this.textTitle_TextChanged);
            this.textTitle.Validating += new System.ComponentModel.CancelEventHandler(this.textTitle_Validating);
            // 
            // buttonClean
            // 
            this.buttonClean.Location = new System.Drawing.Point(128, 323);
            this.buttonClean.Name = "buttonClean";
            this.buttonClean.Size = new System.Drawing.Size(75, 23);
            this.buttonClean.TabIndex = 17;
            this.buttonClean.Text = "Clean";
            this.toolTip1.SetToolTip(this.buttonClean, "Cleans folders if ripping is interupted");
            this.buttonClean.UseVisualStyleBackColor = true;
            this.buttonClean.Click += new System.EventHandler(this.buttonClean_Click);
            // 
            // buttonReadTitle
            // 
            this.buttonReadTitle.Location = new System.Drawing.Point(64, 199);
            this.buttonReadTitle.Name = "buttonReadTitle";
            this.buttonReadTitle.Size = new System.Drawing.Size(75, 23);
            this.buttonReadTitle.TabIndex = 8;
            this.buttonReadTitle.Text = "Read Title";
            this.toolTip1.SetToolTip(this.buttonReadTitle, "Read\'s the movie title from the  Disc");
            this.buttonReadTitle.UseVisualStyleBackColor = true;
            this.buttonReadTitle.Click += new System.EventHandler(this.buttonReadTitle_Click);
            // 
            // progressReadTitle
            // 
            this.progressReadTitle.Location = new System.Drawing.Point(145, 204);
            this.progressReadTitle.Name = "progressReadTitle";
            this.progressReadTitle.Size = new System.Drawing.Size(66, 17);
            this.progressReadTitle.Style = System.Windows.Forms.ProgressBarStyle.Continuous;
            this.progressReadTitle.TabIndex = 19;
            this.toolTip1.SetToolTip(this.progressReadTitle, "Indicates when title is being read");
            // 
            // toolTip1
            // 
            this.toolTip1.BackColor = System.Drawing.Color.LemonChiffon;
            this.toolTip1.IsBalloon = true;
            this.toolTip1.UseAnimation = false;
            this.toolTip1.UseFading = false;
            // 
            // pictureBox1
            // 
            this.pictureBox1.Image = global::VideoRip.Properties.Resources.info;
            this.pictureBox1.Location = new System.Drawing.Point(180, 17);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(24, 24);
            this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pictureBox1.TabIndex = 25;
            this.pictureBox1.TabStop = false;
            this.toolTip1.SetToolTip(this.pictureBox1, "Default - SD for DVD, HD for Blu-Ray\r\nCartoon - 2D cartoon\r\nSD - Standard Definit" +
        "ion 480\r\nHD - High Defition 720\r\nHDX - Extra High Definition 1080\r\nUHD - Ultra H" +
        "igh Definition 4K");
            // 
            // chkBonus
            // 
            this.chkBonus.AutoSize = true;
            this.chkBonus.Location = new System.Drawing.Point(16, 119);
            this.chkBonus.Name = "chkBonus";
            this.chkBonus.Size = new System.Drawing.Size(80, 17);
            this.chkBonus.TabIndex = 23;
            this.chkBonus.Text = "Bonus Disc";
            this.toolTip1.SetToolTip(this.chkBonus, "Check only if disc lacks any movie or episode");
            this.chkBonus.UseVisualStyleBackColor = true;
            // 
            // textLength
            // 
            this.textLength.Location = new System.Drawing.Point(100, 144);
            this.textLength.Name = "textLength";
            this.textLength.Size = new System.Drawing.Size(63, 20);
            this.textLength.TabIndex = 5;
            this.textLength.Visible = false;
            this.textLength.TextChanged += new System.EventHandler(this.textLength_TextChanged);
            this.textLength.Validating += new System.ComponentModel.CancelEventHandler(this.textLength_Validating);
            // 
            // labelSeasonNumber
            // 
            this.labelSeasonNumber.AutoSize = true;
            this.labelSeasonNumber.Location = new System.Drawing.Point(15, 173);
            this.labelSeasonNumber.Name = "labelSeasonNumber";
            this.labelSeasonNumber.Size = new System.Drawing.Size(83, 13);
            this.labelSeasonNumber.TabIndex = 21;
            this.labelSeasonNumber.Text = "Season Number";
            // 
            // textSeasonNumber
            // 
            this.textSeasonNumber.Location = new System.Drawing.Point(141, 170);
            this.textSeasonNumber.Name = "textSeasonNumber";
            this.textSeasonNumber.ReadOnly = true;
            this.textSeasonNumber.Size = new System.Drawing.Size(70, 20);
            this.textSeasonNumber.TabIndex = 7;
            this.textSeasonNumber.Text = "Detect";
            this.textSeasonNumber.TextChanged += new System.EventHandler(this.textSeasonNumber_TextChanged);
            this.textSeasonNumber.Validating += new System.ComponentModel.CancelEventHandler(this.textSeasonNumber_Validating);
            // 
            // checkSeason
            // 
            this.checkSeason.AutoSize = true;
            this.checkSeason.Location = new System.Drawing.Point(120, 170);
            this.checkSeason.Name = "checkSeason";
            this.checkSeason.Size = new System.Drawing.Size(15, 14);
            this.checkSeason.TabIndex = 6;
            this.checkSeason.UseVisualStyleBackColor = true;
            this.checkSeason.CheckedChanged += new System.EventHandler(this.checkSeason_CheckedChanged);
            // 
            // checkTitle
            // 
            this.checkTitle.AutoSize = true;
            this.checkTitle.Location = new System.Drawing.Point(18, 225);
            this.checkTitle.Name = "checkTitle";
            this.checkTitle.Size = new System.Drawing.Size(15, 14);
            this.checkTitle.TabIndex = 9;
            this.checkTitle.UseVisualStyleBackColor = true;
            this.checkTitle.CheckedChanged += new System.EventHandler(this.checkTitle_CheckedChanged);
            // 
            // comboBox1
            // 
            this.comboBox1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBox1.FormattingEnabled = true;
            this.comboBox1.Items.AddRange(new object[] {
            "Default",
            "Cartoon",
            "SD",
            "HD",
            "HDX",
            "UHD"});
            this.comboBox1.Location = new System.Drawing.Point(89, 17);
            this.comboBox1.Name = "comboBox1";
            this.comboBox1.Size = new System.Drawing.Size(84, 21);
            this.comboBox1.TabIndex = 22;
            this.comboBox1.SelectedIndexChanged += new System.EventHandler(this.comboBox1_SelectedIndexChanged);
            // 
            // labelEncoding
            // 
            this.labelEncoding.AutoSize = true;
            this.labelEncoding.Location = new System.Drawing.Point(15, 20);
            this.labelEncoding.Name = "labelEncoding";
            this.labelEncoding.Size = new System.Drawing.Size(52, 13);
            this.labelEncoding.TabIndex = 24;
            this.labelEncoding.Text = "Encoding";
            // 
            // comboRepair
            // 
            this.comboRepair.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboRepair.FormattingEnabled = true;
            this.comboRepair.Items.AddRange(new object[] {
            "Normal",
            "Repair",
            "Restore"});
            this.comboRepair.Location = new System.Drawing.Point(103, 119);
            this.comboRepair.Name = "comboRepair";
            this.comboRepair.Size = new System.Drawing.Size(108, 21);
            this.comboRepair.TabIndex = 24;
            // 
            // Form1
            // 
            this.AcceptButton = this.btnStart;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(604, 358);
            this.Controls.Add(this.comboRepair);
            this.Controls.Add(this.pictureBox1);
            this.Controls.Add(this.labelEncoding);
            this.Controls.Add(this.chkBonus);
            this.Controls.Add(this.comboBox1);
            this.Controls.Add(this.checkTitle);
            this.Controls.Add(this.checkSeason);
            this.Controls.Add(this.textSeasonNumber);
            this.Controls.Add(this.labelSeasonNumber);
            this.Controls.Add(this.textLength);
            this.Controls.Add(this.progressReadTitle);
            this.Controls.Add(this.labelMinutes);
            this.Controls.Add(this.buttonReadTitle);
            this.Controls.Add(this.comboEpisode);
            this.Controls.Add(this.buttonClean);
            this.Controls.Add(this.labelEpisode);
            this.Controls.Add(this.textTitle);
            this.Controls.Add(this.labelTitle);
            this.Controls.Add(this.progressTotal);
            this.Controls.Add(this.progressAction);
            this.Controls.Add(this.tabControl1);
            this.Controls.Add(this.textSpecialInfo);
            this.Controls.Add(this.labelSpecial);
            this.Controls.Add(this.groupMediaType);
            this.Controls.Add(this.textYear);
            this.Controls.Add(this.labelYear);
            this.Controls.Add(this.btnStart);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.Name = "Form1";
            this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide;
            this.Text = "Video Rip";
            this.Activated += new System.EventHandler(this.Form1_Activated);
            this.Deactivate += new System.EventHandler(this.Form1_Deactivate);
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Form1_FormClosing);
            this.Load += new System.EventHandler(this.Form1_Load);
            this.Resize += new System.EventHandler(this.Form1_Resize);
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider1)).EndInit();
            this.groupMediaType.ResumeLayout(false);
            this.groupMediaType.PerformLayout();
            this.tabControl1.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            this.tabPage1.PerformLayout();
            this.tabPage2.ResumeLayout(false);
            this.tabPage2.PerformLayout();
            this.tabSettings.ResumeLayout(false);
            this.tabSettings.PerformLayout();
            this.tabAbout.ResumeLayout(false);
            this.tabAbout.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnStart;
        private System.Windows.Forms.Label labelYear;
        private System.Windows.Forms.TextBox textYear;
        private System.Windows.Forms.ErrorProvider errorProvider1;
        private System.Windows.Forms.Label labelMinutes;
        private System.Windows.Forms.ComboBox comboEpisode;
        private System.Windows.Forms.GroupBox groupMediaType;
        private System.Windows.Forms.RadioButton radioTv;
        private System.Windows.Forms.RadioButton radioFilm;
        private System.Windows.Forms.Label labelEpisode;
        private System.Windows.Forms.RadioButton radioDetect;
        private System.Windows.Forms.TextBox textSpecialInfo;
        private System.Windows.Forms.Label labelSpecial;
        private System.Windows.Forms.ProgressBar progressTotal;
        private System.Windows.Forms.ProgressBar progressAction;
        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.TextBox textStatus;
        private System.Windows.Forms.TabPage tabPage2;
        private System.Windows.Forms.TextBox textLog;
        private System.Windows.Forms.Timer timerStatus;
        private System.Windows.Forms.RadioButton radioMultiFilm;
        private System.Windows.Forms.Button buttonClean;
        private System.Windows.Forms.TextBox textTitle;
        private System.Windows.Forms.Label labelTitle;
        private System.Windows.Forms.Button buttonReadTitle;
        private System.Windows.Forms.ProgressBar progressReadTitle;
        private System.Windows.Forms.TabPage tabSettings;
        private System.Windows.Forms.Button buttonConvertDir;
        private System.Windows.Forms.Button buttonBrowseRip;
        private System.Windows.Forms.TextBox textTempConvertDir;
        private System.Windows.Forms.TextBox textTempRipDir;
        private System.Windows.Forms.Label labelTempConvertDir;
        private System.Windows.Forms.Label labelTempRipping;
        private System.Windows.Forms.ToolTip toolTip1;
        private System.Windows.Forms.TabPage tabAbout;
        private System.Windows.Forms.LinkLabel linkLabel1;
        private System.Windows.Forms.TextBox textLength;
        private System.Windows.Forms.Label labelSeasonNumber;
        private System.Windows.Forms.Label labelValues;
        private System.Windows.Forms.Label labelNames;
        private System.Windows.Forms.Button buttonValue3;
        private System.Windows.Forms.Button buttonValue2;
        private System.Windows.Forms.Button buttonValue1;
        private System.Windows.Forms.TextBox textValue3;
        private System.Windows.Forms.TextBox textValue2;
        private System.Windows.Forms.TextBox textName3;
        private System.Windows.Forms.TextBox textName2;
        private System.Windows.Forms.TextBox textValue1;
        private System.Windows.Forms.TextBox textName1;
        private System.Windows.Forms.Label labelOtherParam;
        private System.Windows.Forms.Button buttonOutputLocation;
        private System.Windows.Forms.TextBox textOutputLocation;
        private System.Windows.Forms.Label labelOutputLocation;
        private System.Windows.Forms.TextBox textSeasonNumber;
        private System.Windows.Forms.CheckBox checkTitle;
        private System.Windows.Forms.CheckBox checkSeason;
        private System.Windows.Forms.Label labelCopyright;
        private System.Windows.Forms.Label labelVersion;
        private System.Windows.Forms.Label labelVideoRip;
        private System.Windows.Forms.Button buttonIsoLang;
        private System.Windows.Forms.TextBox textBoxLanguage;
        private System.Windows.Forms.Label labelLanguage;
        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.Label labelEncoding;
        private System.Windows.Forms.CheckBox chkBonus;
        private System.Windows.Forms.ComboBox comboBox1;
        private System.Windows.Forms.ComboBox comboRepair;
    }
}

