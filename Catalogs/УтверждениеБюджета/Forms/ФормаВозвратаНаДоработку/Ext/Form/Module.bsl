﻿
&НаКлиенте
Процедура ВернутьНаДоработку(Команда)
	Если Не ЗначениеЗаполнено(ПричинаОтмены) Тогда
		Предупреждение("Укажите причину возврата!");
		Возврат;
	КонецЕсли;
	Если АдресВозврата = "Пользователю" И НЕ ЗначениеЗаполнено(Пользователь) Тогда
		Предупреждение("Укажите пользователя!");
		Возврат;
	КонецЕсли;
	Закрыть(Новый Структура("АдресВозврата, ОснованиеЗаблокирован, Пользователь, ПричинаОтмены", АдресВозврата, ОснованиеЗаблокирован, Пользователь, ПричинаОтмены));
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	АдресВозврата = "Автору";
КонецПроцедуры

&НаКлиенте
Процедура АдресВозвратаПриИзменении(Элемент)
	Если АдресВозврата = "Пользователю" Тогда
		Элементы.Пользователь.Видимость = Истина;
	Иначе
		Элементы.Пользователь.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		АдресВозвратаПриИзменении(Неопределено);
		ЭтаФорма.ЗаблокироватьДанныеФормыДляРедактирования();
КонецПроцедуры
