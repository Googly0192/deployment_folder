-- Seed data for violation_types
-- Safe to re-run (idempotent)

INSERT INTO public.violation_types (
    violation_type_id,
    rule_key,
    display_name,
    severity,
    marker_color,
    marker_symbol,
    requires_action,
    description
) VALUES
(1, 'OOS_HARD', 'Out of Specification', 3, '#D90429', 'circle', TRUE, 'Value exceeded absolute engineering tolerances.'),
(2, 'OOS_WARNING', 'Out of Control', 3, '#FB8500', 'circle', TRUE, 'Value exceeded control limits.')
ON CONFLICT (rule_key) DO UPDATE SET
    display_name = EXCLUDED.display_name,
    severity = EXCLUDED.severity,
    marker_color = EXCLUDED.marker_color,
    marker_symbol = EXCLUDED.marker_symbol,
    requires_action = EXCLUDED.requires_action,
    description = EXCLUDED.description;

