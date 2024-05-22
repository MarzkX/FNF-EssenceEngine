using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Drawing.Text;
using System.IO;
using System.Diagnostics;

namespace FlixelCrashHandler
{
    public partial class FlixelCrashHandler : Form
    {
        private string[] crashInfo;
        string appPath = Directory.GetCurrentDirectory();
        public FlixelCrashHandler(string[] args)
        {
            crashInfo = args;
            InitializeComponent();
        }
        public struct LoadedFont
        {
            public Font Font { get; set; }
            public FontFamily FontFamily { get; set; }
        }

        /**
        ** THIS IS FOR LOADING CUSTOM FONTS
        **/
        public static LoadedFont LoadFont(string file, int fontSize, FontStyle fontStyle)
        {
            var fontCollection = new PrivateFontCollection();
            fontCollection.AddFontFile(file);
            if (fontCollection.Families.Length < 0)
            {
                throw new InvalidOperationException("No font familiy found when loading font");
            }

            var loadedFont = new LoadedFont();
            loadedFont.FontFamily = fontCollection.Families[0];
            loadedFont.Font = new Font(loadedFont.FontFamily, fontSize, fontStyle, GraphicsUnit.Pixel);
            return loadedFont;
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            string info = crashInfo[0].Replace("#", "\n");
            if (!File.Exists(appPath+"/bin/crashlogs"))
            {
                Directory.CreateDirectory(appPath+"/bin/crashlogs");
                Console.WriteLine("crashlogs folder not found, creating");
            }
            else
            {
                Console.WriteLine("crashlogs folder found!!!");
            }

            DateTime localTime = DateTime.Now;

            string dateNTime = localTime.Year.ToString() + '/' + localTime.Month.ToString()
            + '/' + localTime.Day.ToString() + ' ' + localTime.Hour.ToString() 
            + ':' + localTime.Minute.ToString() + ':' + localTime.Second.ToString();
            string dateNTimeValid = dateNTime;
            dateNTimeValid = dateNTimeValid.Replace("/", "-");
            dateNTimeValid = dateNTimeValid.Replace(" ", "_");
            dateNTimeValid = dateNTimeValid.Replace(":", "'");

            string logName = "Flixel_" + dateNTimeValid + ".txt";
            string reportInfo = "If your game keeps crashing with the same error, report it to our github. A " + logName + " file has been created.";
            Font PhantomMuff = LoadFont(appPath+"/bin/fonts/vcr.ttf", 16, FontStyle.Regular).Font;
            Font PhantomMuffBig = LoadFont(appPath + "/bin/fonts/vcr.ttf", 24, FontStyle.Regular).Font;

            background.ImageLocation = appPath + "/bin/crashlogs/assets/bg.png";

            infoLabel.Parent = background;
            infoLabel.BackColor = Color.Transparent;
            infoLabel.Text = info;
            infoLabel.ForeColor = Color.White;
            infoLabel.Font = PhantomMuff;

            reportThisText.Font = PhantomMuff;
            reportThisText.Text = reportInfo;
            reportThisText.Parent = background;
            reportThisText.BackColor = Color.Transparent;
            reportThisText.ForeColor = Color.White;

            RelaunchButton.Text = "Relaunch\nGame";
            RelaunchButton.Font = PhantomMuffBig;
            RelaunchButton.Parent = background;
            RelaunchButton.BackColor = Color.Black;
            RelaunchButton.ForeColor = Color.White;
            RelaunchButton.FlatAppearance.MouseDownBackColor = Color.White;
            RelaunchButton.FlatAppearance.MouseOverBackColor = Color.Black;

            Exitbutton.Text = "Exit\n";
            Exitbutton.Font = PhantomMuffBig;
            Exitbutton.Parent = background;
            Exitbutton.BackColor = Color.Black;
            Exitbutton.ForeColor = Color.White;
            Exitbutton.FlatAppearance.MouseDownBackColor = Color.White;
            Exitbutton.FlatAppearance.MouseOverBackColor = Color.Black;
        }

        private void RelaunchButton_Click(object sender, EventArgs e)
        {
            /*string command = "cd/D " + crashInfo[1].Replace("-", "") + " && " + crashInfo[2].Replace("-", "");
            Console.WriteLine(command);
            Process ps = new Process();
            ps.StartInfo.FileName = "cmd.exe";
            ps.StartInfo.CreateNoWindow = true;
            ps.StartInfo.RedirectStandardInput = true;
            ps.StartInfo.RedirectStandardOutput = true;
            ps.StartInfo.UseShellExecute = false;
            ps.Start();
            ps.StandardInput.WriteLine(command);
            ps.StandardInput.Flush();
            ps.StandardInput.Close();*/
            string command = appPath + "/" + crashInfo[1];
            Process.Start(command);
            Application.Exit();
        }

        private void Exitbutton_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }
    }
}
