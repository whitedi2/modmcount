﻿
&НаСервереБезКонтекста
Процедура ЗаполнитьИзСуществующихНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ИсходящаяТранспортнаяОперацияВЕТИС.Ссылка КАК Ссылка,
	|	ИсходящаяТранспортнаяОперацияВЕТИС.ГрузополучательПредприятие КАК ГрузополучательПредприятие
	|ИЗ
	|	Документ.ИсходящаяТранспортнаяОперацияВЕТИС КАК ИсходящаяТранспортнаяОперацияВЕТИС
	|ГДЕ
	|	ИсходящаяТранспортнаяОперацияВЕТИС.Проведен = ИСТИНА";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Ссылка.ДокументОснование) И ЗначениеЗаполнено(Выборка.Ссылка.ДокументОснование.Заказ) Тогда
			НоваяЗаписьРегистра = РегистрыСведений.сабСоответствиеПредприятийВетис.СоздатьМенеджерЗаписи();
			НоваяЗаписьРегистра.ПодразделениеКонтрагента = Выборка.Ссылка.ДокументОснование.Заказ.ПодразделениеКонтрагента;
			НоваяЗаписьРегистра.Предприятие = Выборка.ГрузополучательПредприятие;
			НоваяЗаписьРегистра.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИзСуществующих(Команда)
	ЗаполнитьИзСуществующихНаСервере();
	Элементы.Список.Обновить();
КонецПроцедуры
