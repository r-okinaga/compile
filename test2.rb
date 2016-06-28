class Page
    attr_accessor :name

    def initialize(name)
        @name = name
    end

    def getName
        @name
    end

    def put(indent = 0)
        puts 0.upto(indent).map {'   '}.join + getName
    end
end

class Group < Page
    attr_accessor :children

    def initialize(name)
        super(name)
        @children = []
    end

    def add_child(child)
        @children << child
        self
    end

    def add_children(*children)
        children.each do |child|
            @children << child
        end
        self
    end

    def remove_child(child)
        obj = nil
        @children.find do |item|
            if item.name == child
                obj = item
            end
        end
        if obj == nil
            raise "Not Found #{child}"
        end
        @children.delete(obj)
    end

    def put(indent = 0)
        super(indent)
        @children.each do |child|
            child.put(indent + 1)
        end
    end

    def self.root
        @root ||= Group.new('gCストーリー')
    end
end

class User < Page

    def getName
        "<#{@name}>"
    end
end

class UserService
    def self.create_user(path, *name)
        _create_user(Group.root, path, name)
    end

    def self._create_user(group, path, name)
        if path.length == 0
            name.each do |item|
                group.add_child(User.new(item))
            end
        else
            child_group = group.children.find do |child|
                child.name == path[0]
            end
            case child_group
                when Group

                when NilClass
                    child_group = Group.new(path[0])
                    group.add_child(child_group)
                else
                    raise 'Unknown Class'
            end
            _create_user(child_group, path[1 .. -1], name)
        end
    end

    def self.remove_user(path, *name)
        _remove_user(Group.root, path, name)
    end

    def self._remove_user(group, path, name)
        if path.length == 0
            name.each do |item|
                group.remove_child(item)
            end
        else
            child_group = group.children.find do |child|
                child.name == path[0]
            end
            case child_group
                when Group

                else
                    raise 'Unknown Class'
            end
            _remove_user(child_group, path[1 .. -1], name)
        end
    end
end

Group.root.add_children(
    Group.new('管理本部').add_children(
        Group.new('システムG').add_children(
            User.new('沖永'),
            User.new('久野')
        ),
        Group.new('経理経営管理').add_child(
            User.new('近藤')
        )
    ),
    Group.new('マーケティング').add_children(
        User.new('櫻井'),
        User.new('久保')
    )
)

#Group.root.children[1].remove('久保')

UserService.create_user(['管理本部','システムG'], '遊佐')
Group.root.children[0].children[0].remove_child('遊佐')
UserService.remove_user(['管理本部','システムG'], '沖永', '久野')
Group.root.put