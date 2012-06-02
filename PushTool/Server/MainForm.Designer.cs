namespace Server
{
    partial class MainForm
    {
        /// <summary>
        /// 필수 디자이너 변수입니다.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 사용 중인 모든 리소스를 정리합니다.
        /// </summary>
        /// <param name="disposing">관리되는 리소스를 삭제해야 하면 true이고, 그렇지 않으면 false입니다.</param>
        protected override void Dispose( bool disposing )
        {
            if ( disposing && ( components != null ) )
            {
                components.Dispose();
            }
            base.Dispose( disposing );
        }

        #region Windows Form 디자이너에서 생성한 코드

        /// <summary>
        /// 디자이너 지원에 필요한 메서드입니다.
        /// 이 메서드의 내용을 코드 편집기로 수정하지 마십시오.
        /// </summary>
        private void InitializeComponent()
        {
            this.logs = new System.Windows.Forms.TextBox();
            this.button1 = new System.Windows.Forms.Button();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.lblTextLenth = new System.Windows.Forms.Label();
            this.chkIOS = new System.Windows.Forms.CheckBox();
            this.chkAndroid = new System.Windows.Forms.CheckBox();
            this.chkMentee = new System.Windows.Forms.CheckBox();
            this.chkMentor = new System.Windows.Forms.CheckBox();
            this.button2 = new System.Windows.Forms.Button();
            this.lblTarget = new System.Windows.Forms.Label();
            this.txtTarget = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.chkTarget = new System.Windows.Forms.CheckBox();
            this.chkInit = new System.Windows.Forms.CheckBox();
            this.SuspendLayout();
            // 
            // logs
            // 
            this.logs.Location = new System.Drawing.Point(12, 82);
            this.logs.Multiline = true;
            this.logs.Name = "logs";
            this.logs.ReadOnly = true;
            this.logs.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.logs.Size = new System.Drawing.Size(754, 431);
            this.logs.TabIndex = 0;
            // 
            // button1
            // 
            this.button1.Enabled = false;
            this.button1.Location = new System.Drawing.Point(691, 15);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 21);
            this.button1.TabIndex = 1;
            this.button1.Text = "전송하기";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(12, 15);
            this.textBox1.MaxLength = 100;
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(673, 21);
            this.textBox1.TabIndex = 2;
            this.textBox1.TextChanged += new System.EventHandler(this.textBox1_TextChanged);
            // 
            // lblTextLenth
            // 
            this.lblTextLenth.AutoSize = true;
            this.lblTextLenth.Location = new System.Drawing.Point(14, 1);
            this.lblTextLenth.Name = "lblTextLenth";
            this.lblTextLenth.Size = new System.Drawing.Size(503, 12);
            this.lblTextLenth.TabIndex = 3;
            this.lblTextLenth.Text = "글자수제한 : 아이폰 256byte, 안드로이드 1024byte 이지만, 길게쓰면 전송이 안될 수도 있다.";
            // 
            // chkIOS
            // 
            this.chkIOS.AutoSize = true;
            this.chkIOS.Checked = true;
            this.chkIOS.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chkIOS.Location = new System.Drawing.Point(12, 38);
            this.chkIOS.Name = "chkIOS";
            this.chkIOS.Size = new System.Drawing.Size(44, 16);
            this.chkIOS.TabIndex = 4;
            this.chkIOS.Text = "iOS";
            this.chkIOS.UseVisualStyleBackColor = true;
            this.chkIOS.CheckedChanged += new System.EventHandler(this.chkIOS_CheckedChanged);
            // 
            // chkAndroid
            // 
            this.chkAndroid.AutoSize = true;
            this.chkAndroid.Checked = true;
            this.chkAndroid.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chkAndroid.Location = new System.Drawing.Point(12, 56);
            this.chkAndroid.Name = "chkAndroid";
            this.chkAndroid.Size = new System.Drawing.Size(67, 16);
            this.chkAndroid.TabIndex = 5;
            this.chkAndroid.Text = "Android";
            this.chkAndroid.UseVisualStyleBackColor = true;
            this.chkAndroid.CheckedChanged += new System.EventHandler(this.chkAndroid_CheckedChanged);
            // 
            // chkMentee
            // 
            this.chkMentee.AutoSize = true;
            this.chkMentee.Checked = true;
            this.chkMentee.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chkMentee.Location = new System.Drawing.Point(94, 56);
            this.chkMentee.Name = "chkMentee";
            this.chkMentee.Size = new System.Drawing.Size(66, 16);
            this.chkMentee.TabIndex = 7;
            this.chkMentee.Text = "Mentee";
            this.chkMentee.UseVisualStyleBackColor = true;
            this.chkMentee.CheckedChanged += new System.EventHandler(this.chkMentee_CheckedChanged);
            // 
            // chkMentor
            // 
            this.chkMentor.AutoSize = true;
            this.chkMentor.Checked = true;
            this.chkMentor.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chkMentor.Location = new System.Drawing.Point(94, 38);
            this.chkMentor.Name = "chkMentor";
            this.chkMentor.Size = new System.Drawing.Size(63, 16);
            this.chkMentor.TabIndex = 6;
            this.chkMentor.Text = "Mentor";
            this.chkMentor.UseVisualStyleBackColor = true;
            this.chkMentor.CheckedChanged += new System.EventHandler(this.chkMentor_CheckedChanged);
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(340, 44);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(114, 30);
            this.button2.TabIndex = 8;
            this.button2.Text = ">> 대상확인 >>";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new System.EventHandler(this.button2_Click);
            // 
            // lblTarget
            // 
            this.lblTarget.AutoSize = true;
            this.lblTarget.Location = new System.Drawing.Point(469, 47);
            this.lblTarget.Name = "lblTarget";
            this.lblTarget.Size = new System.Drawing.Size(63, 12);
            this.lblTarget.TabIndex = 9;
            this.lblTarget.Text = "(확인필요)";
            this.lblTarget.Click += new System.EventHandler(this.lblTarget_Click);
            // 
            // txtTarget
            // 
            this.txtTarget.Enabled = false;
            this.txtTarget.Location = new System.Drawing.Point(218, 55);
            this.txtTarget.MaxLength = 255;
            this.txtTarget.Name = "txtTarget";
            this.txtTarget.Size = new System.Drawing.Size(108, 21);
            this.txtTarget.TabIndex = 10;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(167, 60);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(52, 12);
            this.label1.TabIndex = 11;
            this.label1.Text = "특정ID : ";
            // 
            // chkTarget
            // 
            this.chkTarget.AutoSize = true;
            this.chkTarget.Location = new System.Drawing.Point(167, 39);
            this.chkTarget.Name = "chkTarget";
            this.chkTarget.Size = new System.Drawing.Size(99, 16);
            this.chkTarget.TabIndex = 12;
            this.chkTarget.Text = "특정ID만 전송";
            this.chkTarget.UseVisualStyleBackColor = true;
            this.chkTarget.CheckedChanged += new System.EventHandler(this.chkTarget_CheckedChanged);
            // 
            // chkInit
            // 
            this.chkInit.AutoSize = true;
            this.chkInit.Checked = true;
            this.chkInit.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chkInit.Location = new System.Drawing.Point(622, -1);
            this.chkInit.Name = "chkInit";
            this.chkInit.Size = new System.Drawing.Size(144, 16);
            this.chkInit.TabIndex = 13;
            this.chkInit.Text = "전송 후 대화내용 삭제";
            this.chkInit.UseVisualStyleBackColor = true;
            this.chkInit.CheckedChanged += new System.EventHandler(this.chkInit_CheckedChanged);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(778, 519);
            this.Controls.Add(this.chkInit);
            this.Controls.Add(this.chkTarget);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.txtTarget);
            this.Controls.Add(this.lblTarget);
            this.Controls.Add(this.button2);
            this.Controls.Add(this.chkMentee);
            this.Controls.Add(this.chkMentor);
            this.Controls.Add(this.chkAndroid);
            this.Controls.Add(this.chkIOS);
            this.Controls.Add(this.lblTextLenth);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.logs);
            this.Name = "MainForm";
            this.Text = "Meeple Message Pusher";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.Form1_FormClosed);
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox logs;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.Label lblTextLenth;
        private System.Windows.Forms.CheckBox chkIOS;
        private System.Windows.Forms.CheckBox chkAndroid;
        private System.Windows.Forms.CheckBox chkMentee;
        private System.Windows.Forms.CheckBox chkMentor;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.Label lblTarget;
        private System.Windows.Forms.TextBox txtTarget;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.CheckBox chkTarget;
        private System.Windows.Forms.CheckBox chkInit;
    }
}