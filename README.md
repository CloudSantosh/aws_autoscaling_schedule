# Autoscaling

Autoscaling refers to the ability of a system or application to automatically adjust its resource capacity based on the current demand. It is commonly used in cloud computing environments to optimize resource utilization, maintain performance, and ensure cost-efficiency. Autoscaling allows applications to dynamically scale up or down in response to varying workloads, providing the necessary resources during peak periods and reducing them during periods of low demand.

There are several types of autoscaling:

- Vertical Autoscaling: Also known as scaling up or scaling down, this type involves adjusting the capacity of individual resources within an instance. For example, in a virtual machine, vertical autoscaling might involve increasing the amount of CPU, memory, or storage allocated to the instance.

- Horizontal Autoscaling: Also referred to as scaling out or scaling in, this type involves adding or removing instances to meet the changing demand. In horizontal autoscaling, new instances are added to distribute the workload across multiple resources, while instances are removed when the demand decreases. This approach ensures that the system can handle increased traffic or load by adding more resources and saves costs during periods of lower demand by reducing the number of resources.

- Elastic Autoscaling: Elastic autoscaling combines both vertical and horizontal autoscaling. It involves adding or removing instances as well as adjusting the capacity of individual resources within each instance. This type of autoscaling provides flexibility in both dimensions, allowing the system to adapt to changing workloads more efficiently.

- Predictive Autoscaling: Predictive autoscaling uses historical data, workload patterns, and predictive algorithms to anticipate future demand and automatically adjust the resource capacity accordingly. By analyzing past usage patterns, this type of autoscaling can forecast future requirements and proactively scale the system to meet anticipated demand. Predictive autoscaling aims to minimize response time and optimize resource allocation based on predicted workloads.

These autoscaling types can be combined or used independently depending on the specific needs and characteristics of the application or system being scaled. The choice of autoscaling strategy depends on factors such as the nature of the workload, the availability of resources, cost considerations, and the desired performance objectives.

## Here auto scaling on the basis of Schedule

Scheduled autoscaling is a feature provided by cloud computing platforms that allows you to automatically adjust the capacity of your resources based on predefined schedules. It enables you to scale your infrastructure up or down at specific times or days to meet changing workload demands and optimize resource utilization.

With scheduled autoscaling, you can define rules or policies that determine when and how your resources should be scaled. These rules typically specify the minimum and maximum number of instances or resources you want to have active during a given time period.

Here's a general overview of how scheduled autoscaling works:

Define a schedule: Determine the time intervals or specific dates when you want to scale your resources. For example, you may want to scale up during weekdays between 9 AM and 5 PM when your application experiences high traffic.

Configure scaling actions: Specify the desired scaling actions for each schedule. These actions include scaling up (increasing the number of instances/resources) or scaling down (decreasing the number of instances/resources).

Set resource limits: Define the minimum and maximum limits for the number of instances/resources you want to have active. This ensures that autoscaling stays within predefined boundaries.

Monitor and trigger scaling: The cloud platform continuously monitors the time and date according to your defined schedules. When a scheduled time arrives, the autoscaling system triggers the specified scaling action to adjust your resource capacity accordingly.

Scaling execution: The autoscaling system performs the necessary actions to add or remove instances/resources based on the scaling rules and target capacity. It may launch new instances, terminate existing ones, or adjust the configuration of your resources.

Monitoring and feedback: After scaling actions are executed, the system monitors the new resource capacity and workload to ensure it meets your requirements. It provides feedback on the effectiveness of scaling and allows you to fine-tune your autoscaling policies if necessary.

Scheduled autoscaling helps you automate the process of scaling your infrastructure, making it more efficient, cost-effective, and responsive to changing demand patterns. It eliminates the need for manual intervention and allows you to optimize resource allocation based on predictable workload fluctuations.

Here the modules concepts of terraform has been used.

## Structure of the Project is :

<img src="https://github.com/CloudSantosh/aws_autoscaling_terraform/blob/master/image/project_structure.png" width="400" height="600" alignment="center">

## Provisioning the infrastructure the following commands are executed on directory dev_env

### To initialize and loads resources

    terraform init

### To apply infrastructure

    terraform apply --auto-approve

### To destroy the infrastructure

    terraform destroy --auto-approve

### The code for scheduling autoscaling

    #---------------------------------------------
    # create auto scaling policy (scale out)
    #---------------------------------------------
    resource "aws_autoscaling_schedule" "custom-autoscaling-policy-scale-out" {
        scheduled_action_name = "${var.project_name}-auto-scaling-policy-scale-out"
        min_size              = 4
        max_size              = 10
        desired_capacity      = 4
        time_zone             = "Europe/Helsinki"
        //start_time            = "2023-05-25T01:15:00Z"
        //end_time              = "2023-05-25T01:20:00Z"
        recurrence             = "00 12 * * 1-5"
        autoscaling_group_name = aws_autoscaling_group.custom-autoscaling-group.name
        }

    #---------------------------------------------
    # create auto scaling policy (scale in)
    #---------------------------------------------
    resource "aws_autoscaling_schedule" "custom-autoscaling-policy-scale-out" {
        scheduled_action_name = "${var.project_name}-auto-scaling-policy-scale-out"
        min_size              = var.min_size
        max_size              = var.max_size
        desired_capacity      = var.min_size
        time_zone             = "Europe/Helsinki"
        //start_time            = "2023-05-25T01:15:00Z"
        //end_time              = "2023-05-25T01:20:00Z"
        recurrence             = "00 12 * * 1-5"
        autoscaling_group_name = aws_autoscaling_group.custom-autoscaling-group.name
        }

## After running the code

<img src="https://github.com/CloudSantosh/aws_autoscaling_terraform/blob/master/image/autoscaling_cpu.jpeg" width="600" height="400">
