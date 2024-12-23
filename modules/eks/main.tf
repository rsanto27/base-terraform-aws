# -------------------- Security Group ----------------------------
resource "aws_security_group" "base-sg" {
    vpc_id =  var.vpc_id # aws_vpc.base-vpc.id

    # ingress {
    #   from_port   = 0
    #   to_port     = 0
    #   protocol    = "icmp"
    #   cidr_blocks = ["0.0.0.0/0"]  # Permite ping de qualquer lugar
    # }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }
    tags = {
        Name = "${var.prefix}-sg"
    }
}


resource "aws_iam_role" "base-cluster" {
  name = "${var.prefix}-${var.cluster_name}-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}    
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSVPCResourceController" {
  role = aws_iam_role.base-cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
  role = aws_iam_role.base-cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_cloudwatch_log_group" "base-log" {
  name = "/aws/eks-terraform-course/${var.prefix}-${var.cluster_name}/cluster"
  retention_in_days = var.retention_days
}

# ----------------- EKS --------------------------------
resource "aws_eks_cluster" "base-cluster" {
  name = "${var.prefix}-${var.cluster_name}"
  role_arn = aws_iam_role.base-cluster.arn
  enabled_cluster_log_types = ["api","audit"]
  vpc_config {
      subnet_ids = var.subnet_ids # aws_subnet.base-subnets[*].id
      security_group_ids = [aws_security_group.base-sg.id]
  }
  depends_on = [
    aws_cloudwatch_log_group.base-log,
    aws_iam_role_policy_attachment.cluster-AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
  ]
}

# ----------------- nodes-------------------------------

resource "aws_iam_role" "base-node" {
  name = "${var.prefix}-${var.cluster_name}-role-node"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.base-node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.base-node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.base-node.name
}

resource "aws_eks_node_group" "base-node-1" {
  cluster_name = aws_eks_cluster.base-cluster.name
  node_group_name = "node-1"
  node_role_arn = aws_iam_role.base-node.arn
  subnet_ids = var.subnet_ids # aws_subnet.base-subnets[*].id
  instance_types = ["t3.micro"]
  scaling_config {
    desired_size = var.desired_size
    max_size = var.max_size
    min_size = var.min_size
  }
  
  depends_on = [
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly,
  ]
}