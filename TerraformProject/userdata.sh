#!/bin/bash
apt update
apt install -y apache2





# Download the images from S3 bucket
#aws s3 cp s3://myterraformprojectbucket2023/project.webp /var/www/html/project.png --acl public-read

# Create a simple HTML file with the portfolio content and display the images
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Terraform AWS ALB Project</title>
  <style>
    body {
      margin: 0;
      font-family: Arial, Helvetica, sans-serif;
      background: #f4f6f8;
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .card {
      background: #ffffff;
      padding: 40px;
      width: 450px;
      border-radius: 10px;
      text-align: center;
      box-shadow: 0 10px 25px rgba(0,0,0,0.15);
    }

    h1 {
      color: #2d6cdf;
      margin-bottom: 10px;
    }

    .tag {
      display: inline-block;
      background: #2d6cdf;
      color: #ffffff;
      padding: 6px 14px;
      border-radius: 16px;
      font-size: 13px;
      margin-bottom: 20px;
    }

    p {
      color: #444;
      font-size: 15px;
      line-height: 1.6;
    }

    footer {
      margin-top: 25px;
      font-size: 14px;
      color: #666;
    }
  </style>
</head>
<body>
  <div class="card">
    <div class="tag">Terraform + AWS ALB</div>
    <h1>Infrastructure as Code Project-1</h1>
    <p>
      This web server is provisioned using Terraform on AWS.<br>
      Traffic is routed through an Application Load Balancer<br>
      to demonstrate high availability and scalability.
    </p>
    <footer>
      Built for interview demonstration
    </footer>
  </div>
</body>
</html>
EOF

# Start Apache and enable it on boot
systemctl start apache2
systemctl enable apache2