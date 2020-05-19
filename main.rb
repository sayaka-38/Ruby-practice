class Brave

  attr_reader :name, :offense, :defense
  attr_accessor :hp

  SPECIAL_ATTACK_CONSTANT = 1.5

  def initialize(**params)
    @name = params[:name]
    @hp = params[:hp]
    @offense = params[:offense]
    @defense = params[:defense]
  end

  def attack(monster)
    puts "#{name}の攻撃！"

    attack_type = decision_attack_type
    damage = calculate_damage(target: monster, attack_type: attack_type)
    cause_damage(target: monster, damage: damage)

    puts "#{monster.name}の残り体力は#{monster.hp}だ"
  end

  private

  def decision_attack_type
    attack_num = rand(4)
    if attack_num == 0
      puts "急所に当たった！"
      "special_attack"
    else
      puts "通常攻撃"
      "nomal_attack"
    end
  end

  def calculate_damage(**params)
    target = params[:target]
    attack_type = params[:attack_type]

    if attack_type == "special_attack"
      calculate_special_attack - target.defense
    else
      @offense - target.defense
    end
  end

  def cause_damage(**params)
    target = params[:target]
    damage = params[:damage]

    target.hp -= damage
    puts "#{target.name}は#{damage}のダメージを受けた"
  end

  def calculate_special_attack
    @offense * SPECIAL_ATTACK_CONSTANT
  end

end

class Monster

  attr_reader :offense, :defense
  attr_accessor :hp, :name

  PAWER_UP_RATE = 1.5
  CALC_HALF_HP = 0.5

  def initialize(**params)
    @name = params[:name]
    @hp = params[:hp]
    @offense = params[:offense]
    @defense = params[:defense]

    @transform_flag = false
    @trigger_of_transform = params[:hp] * CALC_HALF_HP
  end

  def attack(brave)
    if @hp <= @trigger_of_transform && @transform_flag == false
      @transform_flag = true
      transform
    end
    puts "#{@name}の攻撃！"

    damage = calculate_damage(brave)
    cause_damage(damage: damage, target: brave)

    puts "#{brave.name}の残りHPは#{brave.hp}だ"
  end

  private

  def calculate_damage(brave)
    damage = @offense - brave.defense
  end

  def cause_damage(**params)
    damage = params[:damage]
    target = params[:target]
    target.hp -= damage
    puts "#{target.name}は#{damage}のダメージを受けた！"
  end

  def transform
    transform_name = "ドラゴン"
    puts <<~EOS
    #{@name}は怒っている！
    #{@name}はドラゴンに変身した！
    EOS
    @offense *= PAWER_UP_RATE
    @name = transform_name
  end

end

brave = Brave.new(name: "テリー", hp: 500, offense: 150, defense: 100)
monster = Monster.new(name: "スライム", hp: 250, offense: 200, defense: 100)

brave.attack(monster)
monster.attack(brave)