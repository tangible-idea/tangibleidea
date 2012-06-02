using System.Windows.Forms;
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
            this.lstMentor = new System.Windows.Forms.ListBox();
            this.lstMentee = new System.Windows.Forms.ListBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.btnLogout = new System.Windows.Forms.Button();
            this.btnLogin = new System.Windows.Forms.Button();
            this.txtToAction = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // logs
            // 
            this.logs.BackColor = System.Drawing.Color.Black;
            this.logs.Font = new System.Drawing.Font("돋움", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.logs.ForeColor = System.Drawing.Color.White;
            this.logs.Location = new System.Drawing.Point(12, 12);
            this.logs.Multiline = true;
            this.logs.Name = "logs";
            this.logs.ReadOnly = true;
            this.logs.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.logs.Size = new System.Drawing.Size(634, 423);
            this.logs.TabIndex = 0;
            this.logs.Text = "test";
            // 
            // lstMentor
            // 
            this.lstMentor.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.lstMentor.FormattingEnabled = true;
            this.lstMentor.ItemHeight = 12;
            this.lstMentor.Location = new System.Drawing.Point(666, 29);
            this.lstMentor.Name = "lstMentor";
            this.lstMentor.Size = new System.Drawing.Size(120, 376);
            this.lstMentor.TabIndex = 1;
            this.lstMentor.DrawItem += new System.Windows.Forms.DrawItemEventHandler(this.lstMentor_DrawItem);
            // 
            // lstMentee
            // 
            this.lstMentee.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
            this.lstMentee.FormattingEnabled = true;
            this.lstMentee.ItemHeight = 12;
            this.lstMentee.Location = new System.Drawing.Point(796, 29);
            this.lstMentee.Name = "lstMentee";
            this.lstMentee.Size = new System.Drawing.Size(120, 376);
            this.lstMentee.TabIndex = 2;
            this.lstMentee.DrawItem += new System.Windows.Forms.DrawItemEventHandler(this.lstMentee_DrawItem);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(664, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(114, 12);
            this.label1.TabIndex = 3;
            this.label1.Text = "online mentor (0명)";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(794, 9);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(117, 12);
            this.label2.TabIndex = 4;
            this.label2.Text = "online mentee (0명)";
            // 
            // btnLogout
            // 
            this.btnLogout.Location = new System.Drawing.Point(856, 412);
            this.btnLogout.Name = "btnLogout";
            this.btnLogout.Size = new System.Drawing.Size(27, 23);
            this.btnLogout.TabIndex = 5;
            this.btnLogout.Text = "-";
            this.btnLogout.UseVisualStyleBackColor = true;
            this.btnLogout.Click += new System.EventHandler(this.btnLogout_Click);
            // 
            // btnLogin
            // 
            this.btnLogin.Location = new System.Drawing.Point(889, 412);
            this.btnLogin.Name = "btnLogin";
            this.btnLogin.Size = new System.Drawing.Size(27, 23);
            this.btnLogin.TabIndex = 5;
            this.btnLogin.Text = "+";
            this.btnLogin.UseVisualStyleBackColor = true;
            // 
            // txtToAction
            // 
            this.txtToAction.Location = new System.Drawing.Point(666, 413);
            this.txtToAction.Name = "txtToAction";
            this.txtToAction.Size = new System.Drawing.Size(184, 21);
            this.txtToAction.TabIndex = 6;
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.Menu;
            this.ClientSize = new System.Drawing.Size(925, 440);
            this.Controls.Add(this.txtToAction);
            this.Controls.Add(this.btnLogin);
            this.Controls.Add(this.btnLogout);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.lstMentee);
            this.Controls.Add(this.lstMentor);
            this.Controls.Add(this.logs);
            this.Name = "MainForm";
            this.Text = "MEEPLE SEVER";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.Form1_FormClosed);
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox logs;
        private System.Windows.Forms.ListBox lstMentor;
        private System.Windows.Forms.ListBox lstMentee;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private Button btnLogout;
        private Button btnLogin;
        private TextBox txtToAction;
    }
}