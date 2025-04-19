return {
    data = {
        animations = {
            {
                animation_id = "default",
                animation_keys = {
                    {
                        duration = 0.9,
                        easing = "outsine",
                        end_value = -180,
                        key_type = "tween",
                        node_id = "text",
                        property_id = "position_x",
                    },
                    {
                        duration = 0.95,
                        easing = "outsine",
                        end_value = 40,
                        key_type = "tween",
                        node_id = "green",
                        property_id = "size_x",
                        start_value = 400,
                    },
                    {
                        duration = 0.37,
                        easing = "insine",
                        end_value = 400,
                        key_type = "tween",
                        node_id = "green",
                        property_id = "size_x",
                        start_time = 1.08,
                        start_value = 40,
                    },
                    {
                        duration = 0.71,
                        easing = "outsine",
                        key_type = "tween",
                        node_id = "text",
                        property_id = "position_x",
                        start_time = 1.29,
                        start_value = -180,
                    },
                },
                duration = 2,
            },
        },
        metadata = {
            fps = 60,
            gizmo_steps = {
            },
            gui_path = "/example/examples/widgets/go_widgets/go_widget.gui",
            layers = {
            },
            settings = {
                font_size = 30,
            },
            template_animation_paths = {
            },
        },
        nodes = {
        },
    },
    format = "json",
    type = "animation_editor",
    version = 1,
}