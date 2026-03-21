package main

import input as tfplan

# VARIABLES

required_project_tag := "Personal-Website"

resource_registry := {
    "aws_vpc": {
        "children": {
            "aws_internet_gateway_attachment",
        }
    },
    "aws_subnet": {
        "children": {}
    },
    "aws_internet_gateway": {
        "children": {}
    },
    "aws_nat_gateway": {
        "children": {
            "aws_network_interface",
        }
    },
    "aws_route_table": {
        "children": {
            "aws_route",
            "aws_route_table_association",
        }
    },
    "aws_eip": {
        "children": {
            "aws_eip_association",
        }
    },
    "aws_instance": {
        "children": {
            "aws_network_interface",
        }
    },
    "aws_security_group": {
        "children": {}
    },
    "aws_lb": {
        "children": {
            "aws_lb_listener",
            "aws_lb_listener_rule",
            "aws_lb_target_group_attachment",
        }
    },
    "aws_lb_target_group": {
        "children": {}
    },
    "aws_dynamodb_table": {
        "children": {}
    },
    "aws_ebs_volume": {
        "children": {}
    },
}

tagged_resource_types := {res_type | resource_registry[res_type]}

child_resource_types := {child_res |
    children := resource_registry[_].children
    child_res := children[_]
}

# HELPERS

# True if this change involves creation or update (not just a read/delete).
is_creating_or_updating(resource) if {
    resource.change.actions[_] in {"create", "update"}
}

# True if the resource carries the correct Project tag.
has_project_tag(resource) if {
    resource.change.after.tags["Project"] == required_project_tag
}

# True if this resource type is a known auto-created child.
# These don't need a tag because they have no taggable identity of their own.
is_exempt_child(resource) if {
    resource.type in child_resource_types
}

# True if this resource requires a tag AND we're actually touching it.
requires_tag(resource) if {
    resource.type in tagged_resource_types
    is_creating_or_updating(resource)
}

# RULES

# DENY: a managed resource type is being created/updated without the tag.
deny contains msg if {
    some resource in tfplan.resource_changes
    requires_tag(resource)
    not has_project_tag(resource)
    msg := sprintf(
        "Resource '%s' (type: %s) is missing required tag Project=%s",
        [resource.address, resource.type, required_project_tag]
    )
}

# WARN: an unrecognized resource type is being created ->
# alert to prompt action and help fit it in the resource registry.
warn contains msg if {
    some resource in tfplan.resource_changes
    is_creating_or_updating(resource)
    not resource.type in tagged_resource_types
    not resource.type in child_resource_types
    msg := sprintf(
        "Unclassified resource type '%s' (%s) — add to tagged_resource_types or child_resource_types",
        [resource.type, resource.address]
    )
}