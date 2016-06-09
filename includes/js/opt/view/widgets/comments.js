/*! Copyright 2015 - Silo Web (Compiled: 14-12-2015) */
define([ "Backbone", "model/Comments" ], function(Backbone, Model) {
    "use strict";
    var View = Backbone.View.extend({
        el: ".comments-container",
        events: {
            "click .comment-edit-controls .icon-pencil": "onCommentEdit",
            "click .comment-edit-controls .icon-trash-o": "onCommentDelete",
            "click .save-edit": "onSaveComment",
            "click .cancel-edit": "onCancelEdit",
            "keyup textarea.comment-input": "onCommentKeyup",
            "click .add-new-comment": "onCommentAdd"
        },
        initialize: function(ModelName, ModelId) {
            var _this = this;
            _this.ModelName = ModelName;
            _this.ModelId = ModelId;
            _this.ModelComments = new Model(ModelName, ModelId);
            return _this.setupDefaults().setupSelectors().render();
        },
        setupSelectors: function() {
            return this;
        },
        setupDefaults: function() {
            return this;
        },
        render: function(model) {
            var _this = this;
            var resolve = function(model) {
                var comments = model.attributes.comments;
                var commentsTemplate = _.template($("#comments-template").html());
                $(".comments", $(_this.el)).html("");
                for (var i in comments) {
                    $(".comments", $(_this.el)).append(commentsTemplate(comments[i]));
                }
            };
            if (typeof model !== "undefined") {
                resolve(model);
            } else {
                _this.ModelComments.fetch({
                    success: resolve,
                    error: function(err) {
                        console.log(err);
                    }
                });
            }
            return this;
        },
        onCommentKeyup: function(e) {
            var _this = this;
            var keycode = e.which;
            if (keycode == 13 && !e.shiftKey) {
                e.preventDefault();
                var $comment = $(e.currentTarget);
                var $btn = $comment.next(".save-edit");
                $btn.append('<i class="icon icon-spin icon-spinner"></i>');
                var commentId = $comment.attr("data-commentid");
                var comment = _this._formatComment($comment.val());
                if (commentId === "new") {
                    _this.add(comment, function() {
                        _this.render();
                    });
                } else {
                    _this.update(commentId, comment, function() {
                        _this.render();
                    });
                }
            }
        },
        onCommentAdd: function(e) {
            var _this = this;
            if ($("textarea.comment-input:visibile").length > 0) {
                $("textarea.comment-input").focus();
            } else {
                $(".comments").prepend(_this.commentForm());
                $("textarea.comment-input").focus();
            }
        },
        onCommentEdit: function(e) {
            var _this = this;
            var $icon = $(e.currentTarget);
            $icon.removeClass("icon-pencil").addClass("icon-spin icon-spinner");
            var $container = $icon.closest(".comment-block");
            var commentId = $container.attr("data-commentid");
            var comment = _this._toPlainText($container.find(".panel-body blockquote").html());
            $container.html(_this.commentForm(comment, commentId));
        },
        onCommentDelete: function(e) {
            var _this = this;
            var $icon = $(e.currentTarget);
            $icon.removeClass("icon-trash-o").addClass("icon-spin icon-spinner");
            var $container = $icon.closest(".comment-block");
            $container.find(".panel-heading,.panel-body").addClass("bg-danger");
            var commentId = $container.attr("data-commentid");
            _this.delete(commentId, function() {
                $container.fadeOut(300, function() {
                    _this.render();
                });
            });
        },
        onSaveComment: function(e) {
            var _this = this;
            var $btn = $(e.currentTarget);
            $btn.append('<i class="icon icon-spin icon-spinner"></i>');
            var $comment = $btn.prev("textarea");
            var commentId = $comment.attr("data-commentid");
            var comment = _this._formatComment($comment.val());
            if (commentId === "new") {
                _this.add(comment, function() {
                    _this.render();
                });
            } else {
                _this.update(commentId, comment, function() {
                    _this.render();
                });
            }
        },
        onCancelEdit: function(e) {
            var _this = this;
            var $btn = $(e.currentTarget);
            $btn.append('<i class="icon icon-spin icon-spinner"></i>');
            _this.render();
        },
        commentForm: function(Comment, id) {
            var _this = this;
            var form = _this._textArea(Comment, id);
            form += '<a class="btn btn-xs btn-success pull-right save-edit" style="margin-left: 10px;margin-top: 10px"><i class="fa fa-save"></i> Update Comment</a>';
            form += '<a class="pull-right text-muted cancel-edit" style="margin-top: 10px"><small><i class="fa fa-undo"></i> Cancel</small></a>';
            return form;
        },
        add: function(Comment, cb) {
            var _this = this;
            Comment = _this._formatComment(Comment);
            _this.ModelComments.clear().save({
                comment: Comment
            }, {
                patch: true,
                success: function(model) {
                    _this.render(model);
                },
                error: function(model, response) {
                    console.log(response);
                }
            });
        },
        update: function(commentId, comment, cb) {
            var _this = this;
            Comment = _this._formatComment(comment);
            _this.ModelComments.clear().save({
                commentId: commentId,
                comment: comment
            }, {
                patch: true,
                success: function(model, response) {
                    _this.render(model);
                },
                error: function(model, response) {
                    console.log(response);
                }
            });
        },
        "delete": function(CommentId, cb) {
            var _this = this;
            _this.ModelComments.clear().destroy({
                data: {
                    commentId: CommentId
                },
                success: function(model) {
                    console.log(model);
                    return cb(model, status);
                },
                error: function(model, status) {
                    console.log(err);
                    bootbox.alert("An error occurred while attempting to save your comment.  Please try again.");
                }
            });
        },
        _onCallComplete: function(callResponse, callback) {
            if (typeof callback !== "undefined") {
                callback(callResponse);
            } else {
                return callResponse;
            }
        },
        _textArea: function(Comment, id, type) {
            var _this = this;
            if (typeof Comment === "undefined") Comment = "";
            if (typeof type === "undefined") type = "comment";
            if (typeof id === "undefined") id = "new";
            return '<small class="pull-right text-muted">Shift+Enter=Line Break</small><textarea class="form-control comment-input" data-comment-type="' + type + '" data-commentid="' + id + '">' + _this._toPlainText(Comment.trim()) + "</textarea>";
        },
        _formatComment: function(Comment) {
            Comment = Comment.replace(/(?:\r\n|\r|\n)/g, "<br>");
            if (Comment.substr(Comment.length - 4) === "<br>") Comment = Comment.slice(0, -4);
            return Comment;
        },
        _toPlainText: function(Comment) {
            Comment = Comment.replace(/<br>/g, "\n");
            return Comment;
        }
    });
    return View;
});