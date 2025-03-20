using Godot;
using System;

public partial class main_character : CharacterBody2D
{
    public const float Speed = 300.0f;
    
    private AnimatedSprite2D animatedSprite;
    private string currentAnimation = "idle";
    private bool isAttacking = false;
    private string lastDirectionAnimation = "down_walk"; // Para lembrar a direção quando atacar
    
    public override void _Ready()
    {
        // Obter a referência ao AnimatedSprite2D
        animatedSprite = GetNode<AnimatedSprite2D>("Sprite2D");
        
        // Conectar o sinal de fim de animação
        animatedSprite.AnimationFinished += OnAnimationFinished;
    }

    public override void _PhysicsProcess(double delta)
    {
        // Se estiver atacando, não permitir movimento
        if (isAttacking)
        {
            return;
        }
        

        if (Input.IsActionJustPressed("ui_select"))
        {
            StartAttackAnimation();
            return;
        }
        
        Vector2 velocity = Vector2.Zero;
        Vector2 direction = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down");

        if (direction != Vector2.Zero)
        {
            direction = direction.Normalized();
            velocity = direction * Speed;
            
            // Gerenciar animações baseadas na direção
            string newAnimation;
            
            if (Math.Abs(direction.X) > Math.Abs(direction.Y))
            {
                // Movimento horizontal é predominante
                newAnimation = direction.X > 0 ? "right_walk" : "left_walk";
                lastDirectionAnimation = newAnimation;
            }
            else
            {
                // Movimento vertical é predominante
                newAnimation = direction.Y > 0 ? "down_walk" : "up_walk";
                lastDirectionAnimation = newAnimation;
            }
            
            if (newAnimation != currentAnimation)
            {
                currentAnimation = newAnimation;
                animatedSprite.Play(currentAnimation);
            }
        }
        else
        {
            // Parado
            if (currentAnimation != "stop")
            {
                currentAnimation = "stop";
                animatedSprite.Play(currentAnimation);
            }
        }

        Velocity = velocity;
        MoveAndSlide();
    }
    
    private void StartAttackAnimation()
    {
        isAttacking = true;
        
        // Determinar qual animação de ataque usar baseada na última direção
        string attackAnimation = GetAttackAnimationName();
        
        currentAnimation = attackAnimation;
        animatedSprite.Play(attackAnimation);
    }
    
    private string GetAttackAnimationName()
    {
        // Converte a animação de movimento para a correspondente de ataque
        if (lastDirectionAnimation == "right_walk") return "right_attack";
        if (lastDirectionAnimation == "up_walk") return "up_attack";
        if (lastDirectionAnimation == "down_walk") return "down_attack";
        
        // Padrão caso não tenha direção definida
        return "attack_down";
    }
    
    private void OnAnimationFinished()
    {
        if (isAttacking)
        {
            isAttacking = false;
            
            currentAnimation = "stop";
            animatedSprite.Play("stop");
        }
    }
}