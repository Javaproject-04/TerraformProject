#!/bin/bash
set -e

apt update -y
apt install -y apache2 


# Create stylish HTML page
cat > /var/www/html/index.html <<EOF
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
    <h1>Infrastructure as Code Project-2</h1>
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

systemctl restart apache2
systemctl enable apache2
