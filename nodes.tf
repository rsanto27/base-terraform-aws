# resource "aws_iam_role" "base-node" {
#   name = "${var.prefix}-${var.cluster_name}-role-node"
#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "ec2.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_role_policy_attachment" "node-AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.base-node.name
# }

# resource "aws_iam_role_policy_attachment" "node-AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.base-node.name
# }

# resource "aws_iam_role_policy_attachment" "node-AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.base-node.name
# }

# resource "aws_eks_node_group" "base-node-1" {
#   cluster_name = aws_eks_cluster.base-cluster.name
#   node_group_name = "node-1"
#   node_role_arn = aws_iam_role.base-node.arn
#   subnet_ids = aws_subnet.base-subnets[*].id
#   instance_types = ["t3.micro"]
#   scaling_config {
#     desired_size = var.desired_size
#     max_size = var.max_size
#     min_size = var.min_size
#   }
  
#   depends_on = [
#     aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly,
#   ]
# }